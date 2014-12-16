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

  shared_examples_for 'an action to create an announcement' do
    let(:perform_create) do
      post :create, post_params
    end

    it 'creates a new announcement' do
      expect { perform_create }.to change { Announcement.count }.by(1)
    end

    it 'returns the created announcement' do
      perform_create

      expect(response.body).
          to eq(AnnouncementSerializer.new(Announcement.last).to_json)
    end
  end

  describe 'POST /groups/:group_id/bulletins/:bulletin_id/announcements' do
    context 'with an authenticated user' do
      before do
        request.headers['X-User-Email'] = user.email
        request.headers['X-User-Token'] = user.session_api_key.access_token
      end

     context 'with minimum params required' do
       let(:post_params) { valid_attributes }
       it_behaves_like 'an action to create an announcement'
     end
    end
  end
end
