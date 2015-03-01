require 'rails_helper'

describe Basechurch::V1::PostsController, type: :controller do
  let(:group) do
    create(:group)
  end

  let!(:users) { create_list(:user, 3) }
  let(:logged_user) { create(:user) }

  let(:all_attributes) do
    {
      posts: {
        content: Forgery(:lorem_ipsum).words(10),
        publishedAt: DateTime.now.to_time.iso8601,
        tags: ['tag1', 'tag2', 'tag3'],
        title: Forgery(:lorem_ipsum).title,
        links: {
          group: group.id.to_s
        }
      },
    }
  end

  let(:valid_attributes) do
    {
      posts: {
        content: Forgery(:lorem_ipsum).words(10),
        links: {
          group: group.id.to_s
        }
      }
    }
  end

  # expected variables
  #  - response: The response of an action
  #  - expected_post: The expected post
  shared_examples_for 'a response containing a post' do
    let(:body) { JSON.parse(response.body) }
    it 'returns a post' do
      expect(body['posts']['id']).to eq(expected_post.id.to_s)
      expect(body['posts']['content']).to eq(expected_post.content)
      expect(body['posts']['slug']).to eq(expected_post.slug)
      expect(body['posts']['tags']).to eq(expected_post.tag_list)
      expect(body['posts']['title']).to eq(expected_post.title)
      expect(body['posts']['publishedAt']).to eq(expected_post.published_at.to_time.localtime('+00:00').iso8601)
      expect(body['posts']['links']['group']).to eq(expected_post.group_id.to_s)
      expect(body['posts']['links']['author']).to eq(expected_post.author_id.to_s)

      if expected_post.updated_at
        expect(body['posts']['updatedAt']).to eq(expected_post.updated_at.to_time.localtime('+00:00').iso8601)
      end

      if expected_post.editor
        expect(body['posts']['links']['editor']).to eq(expected_post.editor_id.to_s)
      end
    end
  end

  shared_examples_for 'an action to create a post' do
    let(:perform_action) { post :create, post_params }
    let(:expected_post) { Basechurch::Post.last }

    context 'with an authenticated user' do
      before do
        request.headers['Content-Type'] = 'application/vnd.api+json'
        request.headers['X-User-Email'] = logged_user.email
        request.headers['X-User-Token'] = logged_user.session_api_key.access_token
        allow_any_instance_of(Basechurch::V1::PostResource).
            to receive(:context).and_return(double('current_user' => logged_user))
      end

      it 'creates a new post' do
        expect { perform_action }.to change { Basechurch::Post.count }.by(1)
      end

      context 'with a created post' do
        subject { Basechurch::Post.last }
        before { perform_action }

        its(:author) { should == logged_user }
        its(:content) { should == post_params[:posts][:content] }
        its(:group) { should == group }
        its(:title) { should == post_params[:posts][:title] }
        its(:tag_list) { should == expected_tags }

        it_behaves_like 'a response containing a post'
      end

      it 'contains the published date provided in params' do
        Timecop.freeze do
          perform_action
          expect(Basechurch::Post.last.published_at.utc.to_time.iso8601).
              to eq(DateTime.now.utc.to_time.iso8601)
        end
      end
    end

    it_behaves_like 'an authenticated action'
  end

  shared_examples_for 'an action to update a post' do
    let(:expected_post) { post_to_update.reload }
    let(:perform_action) { put :update, post_params }

    context 'with an authenticated user' do
      before do
        request.headers['Content-Type'] = 'application/vnd.api+json'
        request.headers['X-User-Email'] = logged_user.email
        request.headers['X-User-Token'] = logged_user.session_api_key.access_token
        allow_any_instance_of(Basechurch::V1::PostResource).
            to receive(:context).and_return(double('current_user' => logged_user))
      end

      context 'with an updated post' do
        subject { post_to_update.reload }
        before { perform_action }

        its(:editor) { should == logged_user }
        its(:content) { should == post_params[:posts][:content] }
        its(:group) { should == group }
        its(:title) { should == post_params[:posts][:title] }
        its(:tag_list) { should == expected_tags }

        it_behaves_like 'a response containing a post'
      end
    end

    it_behaves_like 'an authenticated action'

    # it 'contains the published date provided in params' do
    #   perform_create
    #   expect(Post.last.published_at.utc.to_time.iso8601).
    #       to eq(DateTime.now.utc.to_time.iso8601)
    # end
  end

  describe 'GET /posts/:id' do
    let(:expected_post) { create(:post) }

    before { get :show, id: expected_post.id, group_id: expected_post.group_id }

    it_behaves_like 'a response containing a post'
  end

  describe 'POST /posts/:id' do
    context 'with an authenticated user' do
      context 'with minimum params required' do
        let(:post_params) { valid_attributes }
        let(:expected_tags) { [] }
        it_behaves_like 'an action to create a post'
      end

      context 'with all params provided' do
        let(:post_params) { all_attributes }
        let(:expected_tags) { all_attributes[:posts][:tags] }
        it_behaves_like 'an action to create a post'
      end

      context 'with invalid parameters' do
        before do
          request.headers['Content-Type'] = 'application/vnd.api+json'
          request.headers['X-User-Email'] = logged_user.email
          request.headers['X-User-Token'] = logged_user.session_api_key.access_token
          allow_any_instance_of(Basechurch::V1::PostResource).
              to receive(:context).and_return(double('current_user' => logged_user))
        end

        let(:invalid_attributes) { valid_attributes }
        let(:perform_action) { post :create, invalid_attributes }

        context "where published_at is not iso8601 compliant" do
          before do
            invalid_attributes[:posts][:publishedAt] = 'sdafasdfdsa'
            perform_action
          end

          xit 'returns a 422 response code' do
            expect(response.status).to eq(422)
          end
        end
      end
    end
  end

  describe 'PUT /posts/:id' do
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
        let(:expected_tags) { post_params[:posts][:tags] }

        let(:expected_published_at) do
          DateTime.iso8601(post_params[:posts][:publishedAt])
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
          request.headers['Content-Type'] = 'application/vnd.api+json'
          request.headers['X-User-Email'] = logged_user.email
          request.headers['X-User-Token'] = logged_user.session_api_key.access_token
          allow_any_instance_of(Basechurch::V1::PostResource).
              to receive(:context).and_return(double('current_user' => logged_user))
        end

        context "where published_at is not iso8601 compliant" do
          before do
            invalid_attributes[:posts][:publishedAt] = 'sdafasdfdsa'
            perform_action
          end

          subject { response }

          xit 'returns a 422 response code' do
            expect(response.status).to eq(422)
          end
        end
      end
    end
  end
end
