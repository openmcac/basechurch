require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Announcements" do
  let(:response) { JSON.parse(response_body) }

  def expect_announcement(payload, model)
    attributes = payload["attributes"]
    expect(payload["id"]).to eq model.id.to_s
    expect(payload["type"]).to eq "announcements"
    expect(attributes["description"]).to eq model.description
    expect(attributes["url"]).to eq model.url
    expect(attributes["position"]).to eq model.position
  end

  get "api/v1/announcements" do
    let!(:announcements) { create_list(:announcement, 3) }

    example_request "Listing announcements" do
      expect(status).to eq 200
      expect_announcement(response["data"][0], announcements[0])
      expect_announcement(response["data"][1], announcements[1])
      expect_announcement(response["data"][2], announcements[2])
    end
  end

  post "api/v1/announcements" do
    let(:bulletin) { create(:bulletin) }
    let(:response) { JSON.parse(response_body) }

    parameter :type,
      "The type of resource to update",
      scope: [:data],
      required: true

    parameter :description,
      "The announcement body",
      scope: [:data, :attributes],
      required: true

    parameter :type,
      "The bulletin type",
      scope: [:data, :relationships, :bulletin, :data],
      required: true

    parameter :id,
      "The associated bulletin id",
      scope: [:data, :relationships, :bulletin, :data],
      required: true

    let(:data_type) { "announcements" }
    let(:data_attributes_description) { "This is a new description" }
    let(:data_relationships_bulletin_data_type) { "bulletins" }
    let(:data_relationships_bulletin_data_id) { bulletin.id.to_s }

    subject(:created_announcement) { Announcement.find(response["data"]["id"]) }

    example_authenticated_request "Create an announcement" do
      expect(status).to eq 201

      expect(subject.description).to eq data_attributes_description
      expect(subject.bulletin).to eq bulletin

      expect_announcement(response["data"], subject)
    end
  end

  get "api/v1/announcements/:id" do
    let(:announcement) { create(:announcement) }
    let(:id) { announcement.id }

    parameter :id, "The announcement id"

    example_request "Show an announcement" do
      expect(status).to eq 200
      expect_announcement(response["data"], announcement)
    end
  end

  patch "api/v1/announcements/:id" do
    let(:announcement) { create(:announcement) }
    let(:id) { announcement.id }

    parameter :description, "The updated description of the announcement", scope: [:data, :attributes]
    parameter :id, "The id of announcement to update", scope: [:data], required: true
    parameter :position, "The updated position of the announcement", scope: [:data, :attributes]
    parameter :type, "The type of resource to update", scope: [:data]
    parameter :url, "The updated url of the announcement", scope: [:data, :attributes]

    let(:data_id) { announcement.id.to_s }
    let(:data_type) { "announcements" }
    let(:data_attributes_position) { 3 }
    let(:data_attributes_description) { "What an announcement!" }
    let(:data_attributes_url) { "http://example.com" }

    subject { Announcement.find(id) }

    example_authenticated_request "Update an announcement" do
      expect(status).to eq 200

      expect(subject.description).to eq data_attributes_description
      expect(subject.position).to eq data_attributes_position
      expect(subject.url).to eq data_attributes_url

      expect_announcement(response["data"], subject)
    end

    example_authenticated_request "Update an announcement (invalid parameters)",
      "data" => { "attributes" => { "description" => "" } } do
      expect(status).to eq 422
    end
  end

  delete "api/v1/announcements/:id" do
    let(:announcement) { create(:announcement) }
    let(:id) { announcement.id }

    parameter :id, "The id of announcement to delete", required: true

    example_authenticated_request "Delete an announcement" do
      expect(status).to eq 204
      expect(Announcement.where(id: id).pluck(:id)).to be_empty
    end

    example_authenticated_request "Delete an announcement (invalid id)", id: "1212121" do
      expect(status).to eq 404
    end
  end
end
