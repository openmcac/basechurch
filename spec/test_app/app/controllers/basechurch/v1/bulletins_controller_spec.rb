require 'rails_helper'

describe Basechurch::V1::BulletinsController, type: :controller do
  let(:sunday_service) do
    create(:group)
  end

  let(:user) { create(:user) }

  let(:all_attributes) do
    {
      bulletin: {
        publishedAt: DateTime.now.to_time.iso8601,
        name: Forgery(:lorem_ipsum).title,
        description: Forgery(:lorem_ipsum).words(10),
        serviceOrder: Forgery(:lorem_ipsum).words(10),
        group_id: sunday_service.id
      }
    }
  end

  let(:valid_attributes) do
    {
      bulletin: {
        publishedAt: DateTime.now.to_time.iso8601,
        group_id: sunday_service.id
      }
    }
  end

  shared_examples_for 'an action to create a bulletin' do
    let(:perform_action) { post :create, post_params }

    it 'creates a new bulletin' do
      expect { perform_action }.to change { Basechurch::Bulletin.count }.by(1)
    end

    it 'returns the created bulletin' do
      perform_action

      expect(response.body).
          to eq(BulletinSerializer.new(Basechurch::Bulletin.last).to_json)
    end
  end

  shared_examples_for 'a response containing a bulletin' do
    it 'returns a bulletin' do
      body = JSON.parse(response.body)

      expect(body['bulletins']['id']).to eq(bulletin.id.to_s)
      expect(body['bulletins']['name']).to eq(bulletin.name)
      expect(body['bulletins']['description']).to eq(bulletin.description)
      expect(body['bulletins']['publishedAt']).to eq(bulletin.published_at.utc.iso8601)
      expect(body['bulletins']['serviceOrder']).to eq(bulletin.service_order)
      expect(body['bulletins']['links']['group']).to eq(bulletin.group.id.to_s)
      expect(body['bulletins']['links']['announcements']).
          to eq(bulletin.announcements.map { |a| a.id.to_s })
    end
  end

  describe 'GET /sunday' do
    let!(:bulletin) do
      create(:bulletin,
             group: sunday_service,
             display_published_at: 20.seconds.ago.utc.to_time.iso8601)
    end

    let!(:old_bulletin) do
      create(:bulletin,
             group: sunday_service,
             display_published_at: 10.days.ago.utc.to_time.iso8601)
    end

    let!(:future_bulletin) do
      create(:bulletin,
             group: sunday_service,
             display_published_at: 10.days.from_now.utc.to_time.iso8601)
    end

    before { get :sunday }

    it_behaves_like 'a response containing a bulletin'
  end

  describe 'GET /bulletins/:id' do
    let(:bulletin) do
      create(:bulletin_with_announcements,
             display_published_at: '2011-12-03T04:05:06+04:00')
    end

    before { get :show, id: bulletin.id }

    it_behaves_like 'a response containing a bulletin'
  end

  describe 'POST /:group_slug/bulletins' do
    let(:perform_action) { post :create, valid_attributes }

    context 'with an authenticated user' do
      before do
        request.headers['X-User-Email'] = user.email
        request.headers['X-User-Token'] = user.session_api_key.access_token
      end

      context 'with minimum params required' do
        let(:post_params) { valid_attributes }
        it_behaves_like 'an action to create a bulletin'
      end

      context 'with all params provided' do
        let(:post_params) { all_attributes }
        it_behaves_like 'an action to create a bulletin'
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) { valid_attributes }

        context "where published_at is not iso8601 compliant" do
          before do
            invalid_attributes[:bulletin][:publishedAt] = 'sdafasdfdsa'
            perform_action
          end

          subject { response }

          its(:status) { should == 422 }
        end
      end
    end

    it_behaves_like 'an authenticated action'
  end
end
