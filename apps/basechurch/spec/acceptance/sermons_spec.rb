require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Sermons" do
  let(:response) { JSON.parse(response_body) }

  def expect_sermon(payload, model)
    attributes = payload["attributes"]
    expect(payload["id"]).to eq model.id.to_s
    expect(payload["type"]).to eq "sermons"
    expect(attributes["audio-url"]).to eq model.audio_url
    expect(attributes["banner-url"]).to eq model.banner_url
    expect(attributes["name"]).to eq model.name
    expect(attributes["notes"]).to eq model.notes
    expect(attributes["published-at"]).to eq model.published_at.localtime("+00:00").iso8601
    expect(attributes["series"]).to eq model.series
    expect(attributes["speaker"]).to eq model.speaker
    expect(attributes["tags"]).to eq model.tag_list
  end

  get "api/v1/sermons/:id" do
    let(:sermon) { create(:sermon, :completed) }
    let(:id) { sermon.id }

    parameter :id, "The sermon id", required: true

    example_request "Show a sermon" do
      expect(status).to eq 200
      expect_sermon(response["data"], sermon)
    end
  end

  post "api/v1/sermons" do
    let(:group) { create(:group) }
    let(:response) { JSON.parse(response_body) }

    parameter :type,
      "The type of resource to update",
      scope: [:data],
      required: true

    parameter "published-at",
      "The publish date of the sermon is iso8601 format",
      scope: [:data, :attributes],
      required: true

    parameter "banner-url",
      "The banner of the sermon",
      scope: [:data, :attributes]

    parameter "audio-url",
      "The audio file of the sermon",
      scope: [:data, :attributes]

    parameter :name,
      "The sermon name",
      scope: [:data, :attributes],
      required: true

    parameter :notes, "The sermon notes", scope: [:data, :attributes]
    parameter :speaker, "The sermon speaker", scope: [:data, :attributes]
    parameter :series, "The sermon series", scope: [:data, :attributes]
    parameter :tags, "The sermon tags", scope: [:data, :attributes]

    parameter :type,
      "The group type",
      scope: [:data, :relationships, :group, :data],
      required: true

    parameter :id,
      "The associated group id",
      scope: [:data, :relationships, :group, :data],
      required: true

    let(:data_type) { "sermons" }
    let(:data_attributes_published_at) { DateTime.now }
    let("data_attributes_published-at".to_sym) do
      data_attributes_published_at.to_time.localtime("+00:00").iso8601
    end
    let("data_attributes_audio-url".to_sym) do
      "http://example.org/sermon.mp3"
    end
    let("data_attributes_banner-url".to_sym) do
      "http://example.org/banner.png"
    end
    let(:data_attributes_name) { "Random Sermon Name" }
    let(:data_attributes_notes) { "Wow what a great sermon!" }
    let(:data_attributes_speaker) { "Rev. John Doe" }
    let(:data_attributes_series) { "Test Series" }
    let(:data_attributes_tags) { ["faith", "humility"] }
    let(:data_relationships_group_data_type) { "groups" }
    let(:data_relationships_group_data_id) { group.id.to_s }

    subject { Sermon.find(response["data"]["id"]) }

    example_authenticated_request "Create a sermon" do
      expect(status).to eq 201

      expect(subject.published_at.to_time.localtime("+00:00").iso8601).
        to eq data_attributes_published_at.to_time.localtime("+00:00").iso8601
      expect(subject.group).to eq group
      expect(subject.name).to eq data_attributes_name
      expect(subject.notes).to eq data_attributes_notes
      expect(subject.series).to eq data_attributes_series
      expect(subject.speaker).to eq data_attributes_speaker
      expect(subject.tag_list).to eq data_attributes_tags

      expect_sermon(response["data"], subject)
    end

    example_authenticated_request "Create a sermon (invalid parameters)",
      "data" => { "attributes" => { "published-at" => "Not a date" } } do
      expect(status).to eq 422
    end
  end

  patch "api/v1/sermons/:id" do
    let(:sermon) { create(:sermon) }
    let(:id) { sermon.id.to_s }
    let(:group) { create(:group) }
    let(:response) { JSON.parse(response_body) }

    parameter :id,
      "The id of the sermon to update",
      scope: [:data],
      required: true

    parameter :type,
      "The type of resource to update",
      scope: [:data],
      required: true

    parameter "published-at",
      "The publish date of the sermon is iso8601 format",
      scope: [:data, :attributes],
      required: true

    parameter "banner-url",
      "The banner of the sermon",
      scope: [:data, :attributes]

    parameter "audio-url",
      "The audio file of the sermon",
      scope: [:data, :attributes]

    parameter :name,
      "The sermon name",
      scope: [:data, :attributes],
      required: true

    parameter :notes, "The sermon notes", scope: [:data, :attributes]
    parameter :speaker, "The sermon speaker", scope: [:data, :attributes]
    parameter :series, "The sermon series", scope: [:data, :attributes]
    parameter :tags, "The sermon tags", scope: [:data, :attributes]

    parameter :type,
      "The group type",
      scope: [:data, :relationships, :group, :data],
      required: true

    parameter :id,
      "The associated group id",
      scope: [:data, :relationships, :group, :data],
      required: true

    let(:data_type) { "sermons" }
    let(:data_attributes_id) { id.to_s }
    let(:data_attributes_published_at) { DateTime.now }
    let("data_attributes_published-at".to_sym) do
      data_attributes_published_at.to_time.localtime("+00:00").iso8601
    end
    let("data_attributes_audio-url".to_sym) do
      "http://example.org/sermon.mp3"
    end
    let("data_attributes_banner-url".to_sym) do
      "http://example.org/banner.png"
    end
    let(:data_attributes_name) { "Random Sermon Name" }
    let(:data_attributes_notes) { "Wow what a great sermon!" }
    let(:data_attributes_speaker) { "Rev. John Doe" }
    let(:data_attributes_series) { "Test Series" }
    let(:data_attributes_tags) { ["faith", "humility"] }
    let(:data_relationships_group_data_type) { "groups" }
    let(:data_relationships_group_data_id) { group.id.to_s }

    subject { Sermon.find(response["data"]["id"]) }

    example_authenticated_request "Update a sermon" do
      expect(status).to eq 200

      expect(subject.published_at.to_time.localtime("+00:00").iso8601).
        to eq data_attributes_published_at.to_time.localtime("+00:00").iso8601
      expect(subject.group).to eq group
      expect(subject.name).to eq data_attributes_name
      expect(subject.notes).to eq data_attributes_notes
      expect(subject.series).to eq data_attributes_series
      expect(subject.speaker).to eq data_attributes_speaker
      expect(subject.tag_list).to eq data_attributes_tags

      expect_sermon(response["data"], subject)
    end

    example_authenticated_request "Update a sermon (invalid parameters)",
      "data" => { "attributes" => { "published-at" => "Not a date" } } do
      expect(status).to eq 422
    end
  end

  get "api/v1/sermons/sign" do
    let(:directory) { "sermons" }
    it_behaves_like "an endpoint that returns a signature to upload to s3" 
  end
end
