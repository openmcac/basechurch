require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Posts" do
  let(:response) { JSON.parse(response_body) }

  def expect_post(payload, model)
    attributes = payload["attributes"]
    expect(payload["id"]).to eq model.id.to_s
    expect(payload["type"]).to eq "posts"
    expect(attributes["banner-url"]).to eq model.banner_url
    expect(attributes["content"]).to eq model.content
    expect(attributes["kind"]).to eq model.kind
    expect(attributes["published-at"]).to eq model.published_at.localtime("+00:00").iso8601
    expect(attributes["tags"]).to eq model.tag_list.sort
    expect(attributes["title"]).to eq model.title
  end

  get "api/v1/posts/:id" do
    let(:post) { create(:post, :completed) }
    let(:id) { post.id }

    parameter :id, "The post id", required: true

    example_request "Show a post" do
      expect(status).to eq 200
      expect_post(response["data"], post)
    end
  end

  get "api/v1/posts" do
    let!(:posts) { create_list(:post, 3, :completed) }

    example_request "Listing posts" do
      expect(status).to eq 200
      expect_post(response["data"][0], posts[0])
      expect_post(response["data"][1], posts[1])
      expect_post(response["data"][2], posts[2])
    end
  end

  post "api/v1/posts" do
    let(:group) { create(:group) }
    let(:response) { JSON.parse(response_body) }

    parameter :type,
      "The type of resource to update",
      scope: [:data],
      required: true

    parameter "published-at",
      "The publish date of the post in iso8601 format",
      scope: [:data, :attributes]

    parameter "banner-url",
      "The banner of the post",
      scope: [:data, :attributes]

    parameter :title, "The post title", scope: [:data, :attributes]

    parameter :content,
      "The post content",
      scope: [:data, :attributes],
      required: true

    parameter :tags, "The post tags", scope: [:data, :attributes]
    parameter :kind, "The post kind", scope: [:data, :attributes], required: true

    parameter :type,
      "The group type",
      scope: [:data, :relationships, :group, :data],
      required: true

    parameter :id,
      "The associated group id",
      scope: [:data, :relationships, :group, :data],
      required: true

    let(:data_type) { "posts" }
    let(:data_attributes_published_at) { DateTime.now }
    let("data_attributes_published-at".to_sym) do
      data_attributes_published_at.to_time.localtime("+00:00").iso8601
    end
    let("data_attributes_banner-url".to_sym) do
      "http://example.org/banner.png"
    end
    let(:data_attributes_title) { "Random Title" }
    let(:data_attributes_content) { "This is my first post." }
    let(:data_attributes_tags) { ["tag1", "tag2", "tag3"] }
    let(:data_attributes_kind) { "post" }
    let(:data_relationships_group_data_type) { "groups" }
    let(:data_relationships_group_data_id) { group.id.to_s }

    subject { Post.find(response["data"]["id"]) }

    example_authenticated_request "Create a post" do
      expect(status).to eq 201

      expect(subject.published_at.to_time.localtime("+00:00").iso8601).
        to eq data_attributes_published_at.to_time.localtime("+00:00").iso8601
      expect(subject.title).to eq data_attributes_title
      expect(subject.content).to eq data_attributes_content
      expect(subject.tag_list.sort).to eq data_attributes_tags
      expect(subject.kind).to eq data_attributes_kind
      expect(subject.group).to eq group

      expect_post(response["data"], subject)
    end

    example_authenticated_request "Create a post (invalid parameters)",
      "data" => { "attributes" => { "content" => "" } } do
      expect(status).to eq 422
    end
  end

  patch "api/v1/posts/:id" do
    let(:group) { create(:group) }
    let(:post) { create(:post, group: group) }
    let(:id) { post.id }

    parameter :id,
      "The id of post to update",
      scope: [:data],
      required: true

    parameter :type,
      "The type of resource to update",
      scope: [:data],
      required: true

    parameter "published-at",
      "The publish date of the post in iso8601 format",
      scope: [:data, :attributes]

    parameter "banner-url",
      "The banner of the post",
      scope: [:data, :attributes]

    parameter :title, "The post title", scope: [:data, :attributes]

    parameter :content,
      "The post content",
      scope: [:data, :attributes],
      required: true

    parameter :tags, "The post tags", scope: [:data, :attributes]
    parameter :kind, "The post kind", scope: [:data, :attributes], required: true

    parameter :type,
      "The group type",
      scope: [:data, :relationships, :group, :data],
      required: true

    parameter :id,
      "The associated group id",
      scope: [:data, :relationships, :group, :data],
      required: true

    let(:data_id) { id.to_s }
    let(:data_type) { "posts" }
    let(:data_attributes_published_at) { DateTime.now }
    let("data_attributes_published-at".to_sym) do
      data_attributes_published_at.to_time.localtime("+00:00").iso8601
    end
    let("data_attributes_banner-url".to_sym) do
      "http://example.org/banner.png"
    end
    let(:data_attributes_title) { "Random Title" }
    let(:data_attributes_content) { "This is my first post." }
    let(:data_attributes_tags) { ["tag1", "tag2", "tag3"] }
    let(:data_attributes_kind) { "post" }
    let(:data_relationships_group_data_type) { "groups" }
    let(:data_relationships_group_data_id) { group.id.to_s }

    subject { Post.find(id) }

    example_authenticated_request "Update a post" do
      expect(status).to eq 200

      expect(subject.title).to eq data_attributes_title
      expect(subject.content).to eq data_attributes_content
      expect(subject.tag_list.sort).to eq data_attributes_tags
      expect(subject.kind).to eq data_attributes_kind
      expect(subject.group).to eq group

      expect_post(response["data"], subject)
    end

    example_authenticated_request "Update a post (invalid parameters)",
      "data" => { "attributes" => { "content" => "" } } do
      expect(status).to eq 422
      expect(subject.content).to eq post.content
    end
  end

  get "api/v1/posts/sign" do
    let(:directory) { "posts" }
    it_behaves_like "an endpoint that returns a signature to upload to s3" 
  end
end
