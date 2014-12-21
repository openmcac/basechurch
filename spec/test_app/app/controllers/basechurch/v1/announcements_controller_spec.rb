require 'rails_helper'

RSpec.describe Basechurch::V1::AnnouncementsController, type: :controller do
  let(:bulletin) { create(:bulletin) }
  let(:user) { create(:user) }
  let(:announcement_post) { create(:post, group: bulletin.group) }

  let(:valid_attributes) do
    {
      announcement: {
        post_id: announcement_post.id,
        description: Forgery(:lorem_ipsum).words(10)
      },
      group_id: bulletin.group.id,
      bulletin_id: bulletin.id
    }
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
      before do
        request.headers['X-User-Email'] = user.email
        request.headers['X-User-Token'] = user.session_api_key.access_token
      end

      it 'works as expected' do
        # it creates a new announcement
        expect { perform_action }.to change { Basechurch::Announcement.count }.by(1)

        created_announcement = Basechurch::Announcement.last

        # it returns the created announcement
        expect(response.body).
            to eq(AnnouncementSerializer.new(created_announcement).to_json)

        expect(created_announcement.position).to eq(expected_position)
      end

      context 'with invalid parameters' do
        let(:invalid_params) do
          post_params[:announcement][:description] = ''
          post_params
        end

        let(:perform_create) { post action_name, invalid_params }

        it 'fails as expected' do
          # it does not create a new announcement
          expect { perform_create }.to_not change { Basechurch::Announcement.count }

          # it returns a payload with error key
          expect(JSON.parse(response.body).has_key?('error')).to be_truthy
        end
      end
    end

    it_behaves_like 'an authenticated action'
  end

  describe 'POST /groups/:group_id/bulletins/:bulletin_id/announcements' do
    context 'with an authenticated user' do
      context 'with minimum params required' do
        let(:action_name) { :create }
        let(:post_params) { valid_attributes }
        let(:expected_position) { 1 }
        it_behaves_like 'an action to create an announcement'
      end
    end
  end

  describe 'POST /groups/:group_id/bulletins/:bulletin_id/announcements/:position' do
    context 'with an authenticated user' do
      context 'with minimum params required' do
        let(:expected_position) { 2 }
        let(:action_name) { :create_at }
        let!(:bulletin) do
          create(:bulletin_with_announcements, announcements_count: 3)
        end

        let(:post_params) do
          valid_attributes[:position] = expected_position
          valid_attributes
        end

        it_behaves_like 'an action to create an announcement'
      end
    end
  end

  describe 'PATCH /announcements/:id/move/:position' do
    context 'with an authenticated user' do
      before do
        request.headers['X-User-Email'] = user.email
        request.headers['X-User-Token'] = user.session_api_key.access_token
      end

      let(:bulletin) do
        create(:bulletin_with_announcements, announcements_count: 3)
      end

      let(:position) { 2 }

      let(:patch_params) do
        {
          announcement_id: announcement_id,
          position: position
        }
      end

      before { patch :move, patch_params }

      context 'with minimum params required' do
        let(:announcement_id) { bulletin.announcements.last.id }

        it 'moves existing announcement to position specified' do
          expect(Basechurch::Announcement.find(announcement_id).position).to eq(position)
        end
      end

      context 'with invalid parameters' do
        let(:announcement_id) { 121213 }

        it 'fails as expected' do
          # it returns a payload with error key
          expect(JSON.parse(response.body).has_key?('error')).to be_truthy
        end
      end
    end
  end

  describe 'PUT /announcements/:id' do
    let(:bulletin) do
      create(:bulletin_with_announcements, announcements_count: 1)
    end

    let(:announcement) { bulletin.announcements.first }
    let(:description) { Forgery(:lorem_ipsum).words(90) }

    let(:put_params) do
      {
        id: announcement.id,
        announcement: {
          description: description
        }
      }
    end

    let(:perform_action) { put :update, put_params }

    it_behaves_like 'an authenticated action'

    context 'with an authenticated user' do
      before do
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

      context 'with invalid parameters' do
        let(:description) { '' }

        it 'fails as expected' do
          # it doesn't update the announcement description
          expect { perform_action }.
              to_not change { Basechurch::Announcement.find(announcement.id).description }

          # it returns a payload with error key
          expect(JSON.parse(response.body).has_key?('error')).to be_truthy
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
          expect(JSON.parse(response.body).has_key?('error')).to be_truthy
        end
      end
    end

    it_behaves_like 'an authenticated action'
  end
end
