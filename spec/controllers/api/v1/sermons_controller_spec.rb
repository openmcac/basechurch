require 'rails_helper'

describe Api::V1::SermonsController, type: :controller do
  let(:user) { create(:user) }
  let(:group) { create(:group) }

  let(:all_attributes) do
    {
      data: {
        type: "sermons",
        attributes: {
          :"published-at" => DateTime.now.to_time.iso8601,
          name: Forgery(:lorem_ipsum).title,
          notes: Forgery(:lorem_ipsum).words(10),
          speaker: Forgery('name').full_name,
          series: Forgery('lorem_ipsum').title
        },
        relationships: {
          group: {
            data: { type: "groups", id: group.id.to_s }
          }
        }
      }
    }
  end

  let(:full_sermon) do
    b = all_attributes[:data][:attributes]
    create(:sermon,
           published_at: DateTime.iso8601(b[:"published-at"]),
           name: b[:name],
           notes: b[:notes],
           speaker: b[:speaker],
           series: b[:series],
           group: group)
  end

  let(:valid_attributes) do
    {
      data: {
        type: "sermons",
        attributes: {
          :"published-at" => DateTime.now.to_time.iso8601,
          name: Forgery(:lorem_ipsum).title,
          speaker: Forgery('name').full_name
        },
        relationships: {
          group: {
            data: { type: "groups", id: group.id.to_s }
          }
        }
      }
    }
  end

  shared_examples_for 'an action to create a sermon' do
    let(:perform_action) { post :create, post_params }

    it 'creates a new sermon' do
      expect { perform_action }.to change { Sermon.count }.by(1)
    end

    context 'when successful' do
      before { perform_action }
      it_behaves_like 'a response containing a sermon'
    end
  end

  shared_examples_for 'a response containing a sermon' do
    it 'returns a sermon' do
      data = JSON.parse(response.body)["data"]

      expect(data["id"]).to be_present
      expect(data["type"]).to eq "sermons"
      attributes = data["attributes"]
      expect(attributes["audioUrl"]).to eq sermon.audio_url
      expect(attributes["bannerUrl"]).to eq sermon.banner_url
      expect(attributes["name"]).to eq sermon.name
      expect(attributes["published-at"]).
        to eq sermon.published_at.to_time.localtime("+00:00").iso8601
      expect(attributes["notes"]).to eq sermon.notes

      expect(data["relationships"]).to have_key("group")
      expect(data["relationships"]).to have_key("bulletin")
    end
  end

  describe 'GET /sermons/:id' do
    let(:sermon) { create(:sermon) }

    before { get :show, id: sermon.id }

    it_behaves_like 'a response containing a sermon'
  end

  describe "POST /sermons" do
    let(:perform_action) { post :create, valid_attributes }

    context 'with an authenticated user' do
      before do
        auth_headers =
          user.create_new_auth_token.
               merge("Content-Type" => "application/vnd.api+json")
        @request.headers.merge!(auth_headers)
      end

      context 'with minimum params required' do
        let(:post_params) { valid_attributes }
        let(:sermon) do
          iso_date = valid_attributes[:data][:attributes][:"published-at"]
          create(:sermon,
                 published_at: DateTime.iso8601(iso_date),
                 name: valid_attributes[:data][:attributes][:name],
                 notes: valid_attributes[:data][:attributes][:notes],
                 speaker: valid_attributes[:data][:attributes][:speaker],
                 group: group)
        end

        it_behaves_like 'an action to create a sermon'
      end

      context 'with all params provided' do
        let(:post_params) { all_attributes }
        let(:sermon) { full_sermon }
        it_behaves_like 'an action to create a sermon'
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) { valid_attributes }

        context "where published_at is not iso8601 compliant" do
          before do
            attributes = invalid_attributes[:data][:attributes]
            attributes[:"published-at"] = "sdafasdfdsa"
            perform_action
          end

          subject { response }

          its(:status) { should == 422 }
        end
      end
    end

    it_behaves_like 'an authenticated action'
  end

  describe "s3 signing" do
    let(:directory) { "sermons" }
    it_behaves_like "a request that returns a signature to upload to s3"
  end
end
