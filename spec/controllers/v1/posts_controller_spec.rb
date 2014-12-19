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
        tags: ['tag1', 'tag2', 'tag3']
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
    let(:perform_action) { post :create, post_params }

    context 'with an authenticated user' do
      before do
        request.headers['X-User-Email'] = logged_user.email
        request.headers['X-User-Token'] = logged_user.session_api_key.access_token
      end

      it 'creates a new post' do
        expect { perform_action }.to change { Post.count }.by(1)
      end

      it 'returns the created post' do
        perform_action

        expect(response.body).to eq(PostSerializer.new(Post.last).to_json)
      end

      context 'with a created post' do
        subject { Post.last }
        before { perform_action }

        its(:author) { should == logged_user }
        its(:content) { should == post_params[:post][:content] }
        its(:group) { should == group }
        its(:title) { should == post_params[:post][:title] }
        its(:tag_list) { should == expected_tags }
      end

      it 'contains the published date provided in params' do
        Timecop.freeze do
          perform_action
          expect(Post.last.published_at.utc.to_time.iso8601).
              to eq(DateTime.now.utc.to_time.iso8601)
        end
      end
    end

    it_behaves_like 'an authenticated action'
  end

  shared_examples_for 'an action to update a post' do
    let(:perform_action) { put :update, post_params }

    context 'with an authenticated user' do
      before do
        request.headers['X-User-Email'] = logged_user.email
        request.headers['X-User-Token'] = logged_user.session_api_key.access_token
      end

      it 'returns the updated post' do
        perform_action

        expect(response.body).to eq(PostSerializer.new(post_to_update.reload).to_json)
      end

      context 'with an updated post' do
        subject { post_to_update.reload }
        before { perform_action }

        its(:editor) { should == logged_user }
        its(:content) { should == post_params[:post][:content] }
        its(:group) { should == group }
        its(:title) { should == post_params[:post][:title] }
        its(:tag_list) { should == expected_tags }
      end
    end

    it_behaves_like 'an authenticated action'

    # it 'contains the published date provided in params' do
    #   perform_create
    #   expect(Post.last.published_at.utc.to_time.iso8601).
    #       to eq(DateTime.now.utc.to_time.iso8601)
    # end
  end

  describe 'GET /groups/:group_id/posts/:id' do
    let(:new_post) { create(:post) }

    it 'returns a single post' do
      get :show, id: new_post.id, group_id: new_post.group_id
      expect(response.body).to eq(PostSerializer.new(new_post).to_json)
    end
  end

  describe 'POST /groups/:group_id/posts' do
    context 'with an authenticated user' do
      context 'with minimum params required' do
        let(:post_params) { valid_attributes }
        let(:expected_tags) { [] }
        it_behaves_like 'an action to create a post'
      end

      context 'with all params provided' do
        let(:post_params) { all_attributes }
        let(:expected_tags) { all_attributes[:post][:tags] }
        it_behaves_like 'an action to create a post'
      end

      context 'with invalid parameters' do
        before do
          request.headers['X-User-Email'] = logged_user.email
          request.headers['X-User-Token'] = logged_user.session_api_key.access_token
        end

        let(:invalid_attributes) { valid_attributes }
        let(:perform_action) { post :create, invalid_attributes }

        context "where published_at is not iso8601 compliant" do
          before do
            invalid_attributes[:post][:publishedAt] = 'sdafasdfdsa'
            perform_action
          end

          subject { response }

          its(:status) { should == 422 }
        end
      end
    end
  end

  describe 'PUT /groups/:group_id/posts/:post_id' do
    context 'with an authenticated user' do
      let(:post_to_update) { create(:post) }

      context 'with minimum params required' do
        let(:post_params) do
          valid_attributes[:id] = post_to_update.id
          valid_attributes
        end
        let(:expected_tags) { [] }

        it_behaves_like 'an action to update a post'
      end

      context 'with all params provided' do
        let(:post_params) do
          all_attributes[:id] = post_to_update.id
          all_attributes
        end
        let(:expected_tags) { post_params[:post][:tags] }

        let(:expected_published_at) do
          DateTime.iso8601(post_params[:post][:publishedAt])
        end

        it_behaves_like 'an action to update a post'
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) do
          valid_attributes[:id] = post_to_update.id
          valid_attributes
        end

        let(:perform_action) { put :update, invalid_attributes }

        before do
          request.headers['X-User-Email'] = logged_user.email
          request.headers['X-User-Token'] = logged_user.session_api_key.access_token
        end

        context "where published_at is not iso8601 compliant" do
          before do
            invalid_attributes[:post][:publishedAt] = 'sdafasdfdsa'
            perform_action
          end

          subject { response }

          its(:status) { should == 422 }
        end
      end
    end
  end
end
