require 'rails_helper'

describe V1::PostsController do
  let(:group) do
    create(:group)
  end

  let!(:users) { create_list(:user, 3) }
  let(:logged_user) { create(:user) }

  let(:all_attributes) do
    {
      post: {
        publishedAt: DateTime.now.to_time.iso8601,
        title: Forgery(:lorem_ipsum).title,
        content: Forgery(:lorem_ipsum).words(10),
      },
      group_id: group.id
    }
  end

  let(:valid_attributes) do
    {
      post: {
        content: Forgery(:lorem_ipsum).words(10)
      },
      group_id: group.id
    }
  end

  shared_examples_for 'an action to create a post' do
    let(:perform_create) { post :create, post_params }

    it 'creates a new post' do
      expect { perform_create }.to change { Post.count }.by(1)
    end

    it 'returns the created post' do
      perform_create

      expect(response.body).to eq(PostSerializer.new(Post.last).to_json)
    end

    context 'with a created post' do
      subject { Post.last }
      before { perform_create }

      its(:author) { should == logged_user }
      its(:content) { should == post_params[:post][:content] }
      its(:published_at) { should == expected_published_at }
      its(:group) { should == group }
      its(:title) { should == post_params[:post][:title] }
    end
  end

  describe 'GET /groups/:group_id/posts/:id' do
    let(:new_post) { create(:post) }

    it 'returns a single post' do
      get :show, id: new_post.id, group_id: new_post.group_id
      expect(response.body).to eq(PostSerializer.new(new_post).to_json)
    end
  end

  describe 'POST /:group_slug/posts' do
    context 'with an authenticated user' do
      before do
        request.headers['X-User-Email'] = logged_user.email
        request.headers['X-User-Token'] = logged_user.session_api_key.access_token
      end

      context 'with minimum params required' do
        let(:post_params) { valid_attributes }
        let(:expected_published_at) { nil }
        it_behaves_like 'an action to create a post'
      end

      context 'with all params provided' do
        let(:post_params) { all_attributes }
        let(:expected_published_at) do
          DateTime.iso8601(post_params[:post][:publishedAt])
        end

        it_behaves_like 'an action to create a post'
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) { valid_attributes }
        let(:perform_create) { post :create, invalid_attributes }

        context "where published_at is not iso8601 compliant" do
          before do
            invalid_attributes[:post][:publishedAt] = 'sdafasdfdsa'
            perform_create
          end

          subject { response }

          its(:status) { should == 422 }
        end
      end
    end

    context 'with an anonymous user' do
      before { post :create, valid_attributes }

      it 'returns a 302 status code' do
        expect(response.status).to eq(302)
      end

      it 'does not create a post' do
        expect { post :create, valid_attributes }.to_not change { Post.count }
      end
   end
 end
end
