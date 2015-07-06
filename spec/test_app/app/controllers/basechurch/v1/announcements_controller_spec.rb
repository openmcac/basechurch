require 'rails_helper'

RSpec.describe Basechurch::V1::AnnouncementsController, type: :controller do
  let(:bulletin) { create(:bulletin) }
  let(:user) { create(:user) }
  let(:announcement_post) { create(:post, group: bulletin.group) }

  let(:valid_attributes) do
    {
      data: {
        type: "announcements",
        attributes: {
          description: Forgery(:lorem_ipsum).words(10)
        },
        relationships: {
          bulletin: {
            data: { type: "bulletins", id: bulletin.id.to_s }
          },
          post: {
            data: { type: "posts", id: announcement_post.id.to_s }
          }
        }
      }
    }
  end

  shared_examples_for 'a response containing an announcement' do
    it 'returns an announcement' do
      data = JSON.parse(response.body)["data"]
      attributes = data["attributes"]

      expect(data["id"]).to eq announcement.id.to_s
      expect(data["type"]).to eq "announcements"
      expect(attributes["description"]).to eq announcement.description
      expect(attributes["position"]).to eq announcement.position
      expect(attributes["url"]).to eq announcement.url

      bulletin_data = data["relationships"]["bulletin"]["data"]
      expect(bulletin_data["id"]).to eq announcement.bulletin_id.to_s
      expect(bulletin_data["type"]).to eq "bulletins"
    end
  end

  # variables:
  #  - action_name
  #  - post_params
  #  - expected_position
  shared_examples_for 'an action to create an announcement' do
    let(:perform_action) do
      post action_name, post_params
    end

    context 'when authenticated' do
      let(:announcement) { Basechurch::Announcement.last }

      before do
        request.headers['Content-Type'] = 'application/vnd.api+json'
        request.headers['X-User-Email'] = user.email
        request.headers['X-User-Token'] = user.session_api_key.access_token
      end

      it 'works as expected' do
        # it creates a new announcement
        expect { perform_action }.to change { Basechurch::Announcement.count }.by(1)

        expect(announcement.position).to eq(expected_position)
      end

      context 'with valid parameters' do
        before { perform_action }

        it_behaves_like 'a response containing an announcement'
      end

      context 'with invalid parameters' do
        let(:invalid_params) do
          post_params[:data][:attributes][:description] = ""
          post_params
        end

        let(:perform_create) { post action_name, invalid_params }

        it 'fails as expected' do
          # it does not create a new announcement
          expect { perform_create }.to_not change { Basechurch::Announcement.count }

          expect(response.code).to eq("422")
        end
      end
    end

    it_behaves_like 'an authenticated action'
  end

  describe 'POST /announcements' do
    let(:action_name) { :create }

    context 'with an authenticated user' do
      context 'with minimum params required' do
        let(:post_params) { valid_attributes }
        let(:expected_position) { 1 }
        it_behaves_like 'an action to create an announcement'
      end

      context 'with position' do
        let(:expected_position) { 2 }
        let!(:bulletin) do
          create(:bulletin_with_announcements, announcements_count: 3)
        end

        let!(:announcement_before) { bulletin.announcements[0] }
        let!(:announcement_after) { bulletin.announcements[1] }

        let(:post_params) do
          valid_attributes[:data][:attributes][:position] = expected_position
          valid_attributes
        end

        it_behaves_like 'an action to create an announcement'

        it 'shifts the announcements appropriately' do
          request.headers['Content-Type'] = 'application/vnd.api+json'
          request.headers['X-User-Email'] = user.email
          request.headers['X-User-Token'] = user.session_api_key.access_token

          post :create, post_params

          bulletin.reload

          expect(bulletin.announcements[0].position).to eq(1)
          expect(bulletin.announcements[1].position).to eq(3)
          expect(bulletin.announcements[2].position).to eq(4)
          expect(bulletin.announcements[3].position).to eq(2)
        end
      end
    end
  end

  describe 'GET /announcements/:id' do
    let(:announcement) do
      a = create(:bulletin_with_announcements, announcements_count: 1).
        announcements.
        first
      a.url = 'http://nba.com'
      a.save
      a.reload
    end

    before { get :show, id: announcement }

    it_behaves_like 'a response containing an announcement'
  end

  describe "PATCH /announcements/:id" do
    let(:bulletin) do
      create(:bulletin_with_announcements, announcements_count: 1)
    end

    let(:announcement) { bulletin.announcements.first }
    let(:description) { Forgery(:lorem_ipsum).words(90) }

    let(:patch_params) do
      {
        id: announcement.id.to_s,
        data: {
          type: "announcements",
          id: announcement.id.to_s,
          attributes: {
            description: description
          }
        }
      }
    end

    let(:perform_action) { patch :update, patch_params }

    it_behaves_like 'an authenticated action'

    context 'with an authenticated user' do
      before do
        request.headers['Content-Type'] = 'application/vnd.api+json'
        request.headers['X-User-Email'] = user.email
        request.headers['X-User-Token'] = user.session_api_key.access_token
      end

      context 'with minimum params required' do
        before do
          perform_action
        end

        it 'updates the description of the specified announcement' do
          expect(Basechurch::Announcement.find(announcement.id).description).
              to eq(description)
        end
      end

      context 'with a position provided' do
        let!(:bulletin) do
          create(:bulletin_with_announcements, announcements_count: 3)
        end

        let(:position) { 3 }

        let(:patch_params) do
          {
            id: bulletin.announcements[1].id.to_s,
            data: {
              type: "announcements",
              id: bulletin.announcements[1].id.to_s,
              attributes: {
                position: position
              }
            }
          }
        end

        before { perform_action }

        context 'with minimum params required' do
          let(:announcement_id) { announcement.id }
          before { bulletin.reload }

          it 'moves existing announcement to position specified' do
            expect(bulletin.announcements[0].position).to eq(1)
            expect(bulletin.announcements[1].position).to eq(3)
            expect(bulletin.announcements[2].position).to eq(2)
          end
        end
      end

      context 'with invalid parameters' do
        let(:description) { '' }

        it 'fails as expected' do
          # it doesn't update the announcement description
          expect { perform_action }.
              to_not change { Basechurch::Announcement.find(announcement.id).description }

          expect(response.code).to eq('422')
        end
      end
    end
  end

  describe 'DELETE /announcements/:id' do
    let!(:announcements) { create_list(:announcement, 3) }

    let(:announcement) { announcements[1] }

    let(:delete_params) { { id: announcement.id } }

    let(:perform_delete) { delete :destroy, delete_params }

    let(:perform_action) { perform_delete }

    context 'with an authenticated user' do
      before do
        request.headers['Content-Type'] = 'application/vnd.api+json'
        request.headers['X-User-Email'] = user.email
        request.headers['X-User-Token'] = user.session_api_key.access_token
      end

      it 'deletes the announcement specified' do
        expect { perform_delete }.to change { Basechurch::Announcement.count }.by(-1)
        expect(Basechurch::Announcement.where(id: announcement.id)).to be_empty
      end

      context 'with invalid parameters' do
        let(:delete_params) { { id: 1231231 } }

        it 'fails as expected' do
          # it doesn't delete the announcement
          expect { perform_delete }.to_not change { Basechurch::Announcement.count }

          # it returns a payload with error key
          expect(response.code).to eq('404')
        end
      end
    end

    it_behaves_like 'an authenticated action'
  end
end
