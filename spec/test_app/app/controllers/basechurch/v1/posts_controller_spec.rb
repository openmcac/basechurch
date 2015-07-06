require 'rails_helper'

describe Basechurch::V1::PostsController, type: :controller do
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
          title: Forgery(:lorem_ipsum).title
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
      expect(attributes["tags"]).to eq expected_post.tag_list
      expect(attributes["title"]).to eq expected_post.title
      expect(attributes["published-at"]).
        to eq expected_post.published_at.to_time.localtime("+00:00").iso8601

      expect(group_data["id"]).to eq expected_post.group_id.to_s
      expect(group_data["type"]).to eq "groups"

      expect(author_data["id"]).to eq expected_post.author_id.to_s
      expect(author_data["type"]).to eq "users"

      if expected_post.updated_at
        expect(attributes["updated-at"]).
          to eq expected_post.updated_at.to_time.localtime("+00:00").iso8601
      end

      if expected_post.editor
        expect(editor_data["id"]).to eq expected_post.editor_id.to_s
        expect(editor_data["type"]).to eq "users"
      end
    end
  end

  shared_examples_for 'an action to create a post' do
    let(:perform_action) { post :create, post_params }
    let(:expected_post) { Basechurch::Post.last }

    context 'with an authenticated user' do
      before do
        request.headers["Content-Type"] = "application/vnd.api+json"
        request.headers["X-User-Email"] = user.email
        request.headers["X-User-Token"] = user.session_api_key.access_token
        allow_any_instance_of(Basechurch::V1::PostResource).
          to receive(:context).and_return(current_user: user)
      end

      it 'creates a new post' do
        expect { perform_action }.to change { Basechurch::Post.count }.by(1)
      end

      context 'with a created post' do
        subject { Basechurch::Post.last }
        before { perform_action }

        its(:author) { should == user }
        its(:content) { should == post_params[:data][:attributes][:content] }
        its(:group) { should == group }
        its(:title) { should == post_params[:data][:attributes][:title] }
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
    let(:perform_action) { patch :update, post_params }

    context 'with an authenticated user' do
      before do
        request.headers["Content-Type"] = "application/vnd.api+json"
        request.headers["X-User-Email"] = user.email
        request.headers["X-User-Token"] = user.session_api_key.access_token
        allow_any_instance_of(Basechurch::V1::PostResource).
          to receive(:context).and_return(current_user: user)
      end

      context 'with an updated post' do
        subject { post_to_update.reload }
        before { perform_action }

        its(:editor) { should == user }
        its(:content) { should == post_params[:data][:attributes][:content] }
        its(:group) { should == group }
        its(:title) { should == post_params[:data][:attributes][:title] }
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
        let(:expected_tags) { all_attributes[:data][:attributes][:tags] }
        it_behaves_like 'an action to create a post'
      end

      context 'with invalid parameters' do
        before do
          request.headers["Content-Type"] = "application/vnd.api+json"
          request.headers["X-User-Email"] = user.email
          request.headers["X-User-Token"] = user.session_api_key.access_token
          allow_any_instance_of(Basechurch::V1::PostResource).
            to receive(:context).and_return(current_user: user)
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

        it_behaves_like 'an action to update a post'
      end

      context 'with all params provided' do
        let(:post_params) do
          all_attributes[:data][:id] = post_to_update.id
          all_attributes[:id] = post_to_update.id
          all_attributes
        end
        let(:expected_tags) { post_params[:data][:attributes][:tags] }

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
          request.headers["Content-Type"] = "application/vnd.api+json"
          request.headers["X-User-Email"] = user.email
          request.headers["X-User-Token"] = user.session_api_key.access_token
          allow_any_instance_of(Basechurch::V1::PostResource).
            to receive(:context).and_return(current_user: user)
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
