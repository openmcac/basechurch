require 'rails_helper'

RSpec.describe V1::AnnouncementsController, :type => :controller do
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
    let(:perform_create) do
      post action_name, post_params
    end

    it 'works as expected' do
      # it creates a new announcement
      expect { perform_create }.to change { Announcement.count }.by(1)

      created_announcement = Announcement.last

      # it returns the created announcement
      expect(response.body).
          to eq(AnnouncementSerializer.new(created_announcement).to_json)

      expect(created_announcement.position).to eq(expected_position)
    end
  end

  describe 'POST /groups/:group_id/bulletins/:bulletin_id/announcements' do
    context 'with an authenticated user' do
      before do
        request.headers['X-User-Email'] = user.email
        request.headers['X-User-Token'] = user.session_api_key.access_token
      end

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
      before do
        request.headers['X-User-Email'] = user.email
        request.headers['X-User-Token'] = user.session_api_key.access_token
      end

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

  describe 'PUT /announcements/:id' do
    context 'with an authenticated user' do
      before do
        request.headers['X-User-Email'] = user.email
        request.headers['X-User-Token'] = user.session_api_key.access_token
      end

      context 'with minimum params required' do
        let(:bulletin) do
          create(:bulletin_with_announcements, announcements_count: 3)
        end
        let(:position) { 2 }
        let(:announcement_id) { bulletin.announcements.last.id }

        let(:patch_params) do
          {
            announcement_id: announcement_id,
            position: position
          }
        end

        before do
          patch :move, patch_params
        end

        it 'moves existing announcement to position specified' do
          expect(Announcement.find(announcement_id).position).to eq(position)
        end
      end
    end
  end

  describe 'PATCH /announcements/:id/move/:position' do
    context 'with an authenticated user' do
      before do
        request.headers['X-User-Email'] = user.email
        request.headers['X-User-Token'] = user.session_api_key.access_token
      end

      context 'with minimum params required' do
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

        before do
          put :update, put_params
        end

        it 'updates the description of the specified announcement' do
          expect(Announcement.find(announcement.id).description).
              to eq(description)
        end
      end
    end
  end
end
