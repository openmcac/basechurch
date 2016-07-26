require 'rails_helper'

describe Api::V1::PostsController, type: :controller do
  let(:group) { create(:group) }

  let(:user) { create(:user) }

  let(:all_attributes) do
    {
      data: {
        type: "posts",
        attributes: {
          content: Forgery(:lorem_ipsum).words(10),
          :"published-at" => DateTime.now.to_time.iso8601,
          tags: ["tag1", "tag2", "tag3"],
          title: Forgery(:lorem_ipsum).title,
          kind: "post"
        },
        relationships: {
          group: {
            data: { type: "groups", id: group.id.to_s }
          }
        }
      }
    }
  end

  let(:valid_attributes) do
    {
      data: {
        type: "posts",
        attributes: {
          content: Forgery(:lorem_ipsum).words(10)
        },
        relationships: {
          group: {
            data: { type: "groups", id: group.id.to_s }
          }
        }
      }
    }
  end

  # expected variables
  #  - response: The response of an action
  #  - expected_post: The expected post
  shared_examples_for 'a response containing a post' do
    let(:data) { JSON.parse(response.body)["data"] }
    let(:attributes) { data["attributes"] }
    let(:group_data) { data["relationships"]["group"]["data"] }
    let(:author_data) { data["relationships"]["author"]["data"] }
    let(:editor_data) { data["relationships"]["editor"]["data"] }

    it 'returns a post' do
      expect(data["id"]).to eq expected_post.id.to_s

      expect(attributes["content"]).to eq expected_post.content
      expect(attributes["slug"]).to eq expected_post.slug
      expect(attributes["tags"]).to match_array(expected_post.tag_list)
      expect(attributes["title"]).to eq expected_post.title
      expect(attributes["kind"]).to eq expected_post.kind
      expect(attributes["published-at"]).
        to eq expected_post.published_at.to_time.localtime("+00:00").iso8601

      expect(data["relationships"]).to have_key("group")
      expect(data["relationships"]).to have_key("author")
      expect(data["relationships"]).to have_key("editor")

      if expected_post.updated_at
        expect(attributes["updated-at"]).
          to eq expected_post.updated_at.to_time.localtime("+00:00").iso8601
      end
    end
  end

  shared_examples_for 'an action to create a post' do
    let(:perform_action) { post :create, post_params }
    let(:expected_post) { Post.last }

    context 'with an authenticated user' do
      before do
        auth_headers =
          user.create_new_auth_token.
               merge("Content-Type" => "application/vnd.api+json")
        @request.headers.merge!(auth_headers)
      end

      it 'creates a new post' do
        expect { perform_action }.to change { Post.count }.by(1)
      end

      context 'with a created post' do
        subject { Post.last }
        before { perform_action }

        its(:author) { should == user }
        its(:content) { should == post_params[:data][:attributes][:content] }
        its(:group) { should == group }
        its(:title) { should == post_params[:data][:attributes][:title] }
        its(:tag_list) { is_expected.to match_array(expected_tags) }
        its(:kind) { should == expected_kind }

        it_behaves_like 'a response containing a post'
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
    let(:expected_post) { post_to_update.reload }
    let(:perform_action) { patch :update, post_params }

    context 'with an authenticated user' do
      before do
        auth_headers =
          user.create_new_auth_token.
               merge("Content-Type" => "application/vnd.api+json")
        @request.headers.merge!(auth_headers)
      end

      context 'with an updated post' do
        subject { post_to_update.reload }
        before { perform_action }

        its(:editor) { should == user }
        its(:content) { should == post_params[:data][:attributes][:content] }
        its(:group) { should == group }
        its(:title) { should == post_params[:data][:attributes][:title] }
        its(:tag_list) { is_expected.to match_array(expected_tags) }
        its(:kind) { should == expected_kind }

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

  describe "GET /posts" do
    before { get :index }

    it "does not require authentication" do
      expect(response.status).to eq 200
    end
  end

  describe 'POST /posts/:id' do
    context 'with an authenticated user' do
      context 'with minimum params required' do
        let(:post_params) { valid_attributes }
        let(:expected_tags) { [] }
        let(:expected_kind) { "post" }
        it_behaves_like 'an action to create a post'
      end

      context 'with all params provided' do
        let(:post_params) { all_attributes }
        let(:expected_tags) { all_attributes[:data][:attributes][:tags] }
        let(:expected_kind) { "post" }
        it_behaves_like 'an action to create a post'
      end

      context 'when creating a page' do
        let(:post_params) do
          all_attributes[:data][:attributes][:kind] = "page"
          all_attributes
        end
        let(:expected_tags) { all_attributes[:data][:attributes][:tags] }
        let(:expected_kind) { "page" }
        it_behaves_like 'an action to create a post'
      end

      context 'with invalid parameters' do
        before do
          auth_headers =
            user.create_new_auth_token.
                 merge("Content-Type" => "application/vnd.api+json")
          @request.headers.merge!(auth_headers)
        end

        let(:invalid_attributes) { valid_attributes }
        let(:perform_action) { post :create, invalid_attributes }

        context "where published_at is not iso8601 compliant" do
          before do
            invalid_attributes[:posts][:"published-at"] = "sdafasdfdsa"
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
          valid_attributes[:data][:id] = post_to_update.id
          valid_attributes[:id] = post_to_update.id
          valid_attributes
        end
        let(:expected_tags) { [] }
        let(:expected_kind) { post_to_update.kind.to_s }

        it_behaves_like 'an action to update a post'
      end

      context 'with all params provided' do
        let(:post_params) do
          all_attributes[:data][:id] = post_to_update.id
          all_attributes[:id] = post_to_update.id
          all_attributes[:data][:attributes][:kind] = "page"
          all_attributes
        end
        let(:expected_tags) { post_params[:data][:attributes][:tags] }
        let(:expected_kind) { post_params[:data][:attributes][:kind] }

        let(:expected_published_at) do
          DateTime.iso8601(post_params[:data][:attributes][:"published-at"])
        end

        it_behaves_like 'an action to update a post'
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) do
          valid_attributes[:data][:id] = post_to_update.id
          valid_attributes[:id] = post_to_update.id
          valid_attributes
        end

        let(:perform_action) { put :update, invalid_attributes }

        before do
          auth_headers =
            user.create_new_auth_token.
                 merge("Content-Type" => "application/vnd.api+json")
          @request.headers.merge!(auth_headers)
        end

        context "where published_at is not iso8601 compliant" do
          before do
            attributes = invalid_attributes[:data][:attributes]
            attributes[:"published-at"] = "sdafasdfdsa"
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

  describe "s3 signing" do
    let(:directory) { "posts" }
    it_behaves_like "a request that returns a signature to upload to s3"
  end
end
