require 'rails_helper'

describe Basechurch::V1::BulletinsController, type: :controller do
  let(:sunday_service) do
    create(:group)
  end

  let(:user) { create(:user) }

  let(:all_attributes) do
    {
      bulletins: {
        publishedAt: DateTime.now.to_time.iso8601,
        name: Forgery(:lorem_ipsum).title,
        description: Forgery(:lorem_ipsum).words(10),
        serviceOrder: Forgery(:lorem_ipsum).words(10),
        links: {
          group: sunday_service.id.to_s
        }
      }
    }
  end

  let(:full_bulletin) do
    b = all_attributes[:bulletins]
    create(:bulletin,
           published_at: DateTime.iso8601(b[:publishedAt]),
           name: b[:name],
           description: b[:description],
           service_order: b[:serviceOrder],
           group: sunday_service)
  end

  let(:valid_attributes) do
    {
      bulletins: {
        publishedAt: DateTime.now.to_time.iso8601,
        links: {
          group: sunday_service.id.to_s
        }
      }
    }
  end

  shared_examples_for 'an action to create a bulletin' do
    let(:perform_action) { post :create, post_params }

    it 'creates a new bulletin' do
      expect { perform_action }.to change { Basechurch::Bulletin.count }.by(1)
    end

    context 'when successful' do
      before { perform_action }
      it_behaves_like 'a response containing a bulletin'
    end
  end

  shared_examples_for 'a response containing a bulletin' do
    it 'returns a bulletin' do
      body = JSON.parse(response.body)

      expect(body['bulletins']['id']).to be_present
      expect(body['bulletins']['name']).to eq(bulletin.name)
      expect(body['bulletins']['description']).to eq(bulletin.description)
      expect(body['bulletins']['publishedAt']).to eq(bulletin.published_at.to_time.localtime('+00:00').iso8601)
      expect(body['bulletins']['serviceOrder']).to eq(bulletin.service_order)
      expect(body['bulletins']['links']['group']).to eq(bulletin.group.id.to_s)
      expect(body['bulletins']['links']['announcements']).
          to eq(bulletin.announcements.map { |a| a.id.to_s })
    end
  end

  describe 'GET /sunday' do
    let!(:bulletin) do
      create(:bulletin, group: sunday_service, published_at: 20.seconds.ago)
    end

    let!(:old_bulletin) do
      create(:bulletin, group: sunday_service, published_at: 10.days.ago)
    end

    let!(:future_bulletin) do
      create(:bulletin, group: sunday_service, published_at: 10.days.from_now)
    end

    before { get :sunday }

    it_behaves_like 'a response containing a bulletin'
  end

  describe 'GET /bulletins/:id' do
    let(:bulletin) do
      create(:bulletin_with_announcements,
             published_at: DateTime.iso8601('2011-12-03T04:05:06+04:00'))
    end

    before { get :show, id: bulletin.id }

    it_behaves_like 'a response containing a bulletin'
  end

  describe 'POST /:group_slug/bulletins' do
    let(:perform_action) { post :create, valid_attributes }

    context 'with an authenticated user' do
      before do
        request.headers['Content-Type'] = 'application/vnd.api+json'
        request.headers['X-User-Email'] = user.email
        request.headers['X-User-Token'] = user.session_api_key.access_token
      end

      context 'with minimum params required' do
        let(:post_params) { valid_attributes }
        let(:bulletin) do
          isoDate = valid_attributes[:bulletins][:publishedAt]
          create(:bulletin,
                 published_at: DateTime.iso8601(isoDate),
                 group: sunday_service)
        end

        it_behaves_like 'an action to create a bulletin'
      end

      context 'with all params provided' do
        let(:post_params) { all_attributes }
        let(:bulletin) { full_bulletin }
        it_behaves_like 'an action to create a bulletin'
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) { valid_attributes }

        context "where published_at is not iso8601 compliant" do
          before do
            invalid_attributes[:bulletins][:publishedAt] = 'sdafasdfdsa'
            perform_action
          end

          subject { response }

          its(:status) { should == 422 }
        end
      end
    end

    it_behaves_like 'an authenticated action'
  end

  describe "#sign" do
    context "when unauthenticated" do
      before do
        get :sign, name: "myfile.jpg", size: 12343, type: "image/jpeg"
      end

      it "requires authentication" do
        expect(response.status).to eq(302)
      end
    end

    context "with a signed in user" do
      let(:policy) do
        "eyJleHBpcmF0aW9uIjoiMjAxMy0wNS0xNFQwMjo0ODoyNi4wMDBaIiwiY29uZGl0a" +
          "W9ucyI6W3siYnVja2V0IjoibWNhYy10ZXN0In0seyJhY2wiOiJwdWJsaWMtcmVhZC" +
          "J9LHsiZXhwaXJlcyI6IjIwMTMtMDUtMTRUMDI6NDg6MjYuMDAwWiJ9LHsic3VjY2V" +
          "zc19hY3Rpb25fc3RhdHVzIjoiMjAxIn0sWyJzdGFydHMtd2l0aCIsIiRrZXkiLCIi" +
          "XSxbInN0YXJ0cy13aXRoIiwiJENvbnRlbnQtVHlwZSIsIiJdLFsic3RhcnRzLXdpd" +
          "GgiLCIkQ2FjaGUtQ29udHJvbCIsIiJdLFsiY29udGVudC1sZW5ndGgtcmFuZ2UiLD" +
          "AsNTI0Mjg4MDAwXV19"
      end

      before { sign_in user }

      before do
        allow_any_instance_of(RandomFilename).
          to receive(:generate).and_return("random.jpg")

        Timecop.freeze(DateTime.iso8601("2013-05-13T22:18:26-04:00")) do
          get :sign, name: "myfile.jpg", size: 12343, type: "image/jpeg"
        end
      end

      it "responds with values to post to s3" do
        json = JSON.parse(response.body)
        expect(json["acl"]).to eq "public-read"
        expect(json["awsAccessKeyId"]).
          to eq Rails.application.secrets.aws_access_key_id
        expect(json["bucket"]).to eq "mcac-test"
        expect(json["Cache-Control"]).to eq "max-age=630720000, public"
        expect(json["Content-Type"]).to eq "image/jpeg"
        expect(json["expires"]).to eq "2013-05-14T02:48:26.000Z"
        expect(json["key"]).to eq "bulletins/random.jpg"
        expect(json["policy"]).to eq policy
        expect(json["signature"]).to eq "IS1HheFL3YkG/kr0hMyzwphOmNM="
        expect(json["success_action_status"]).to eq "201"
      end
    end
  end
end
