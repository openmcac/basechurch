require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Groups" do
  let(:response) { JSON.parse(response_body) }

  def expect_group(payload, model)
    attributes = payload["attributes"]
    expect(payload["id"]).to eq model.id.to_s
    expect(payload["type"]).to eq "groups"
    expect(attributes["about"]).to eq model.about
    expect(attributes["banner-url"]).to eq model.banner_url
    expect(attributes["created-at"]).to eq model.created_at.localtime("+00:00").iso8601
    expect(attributes["meet-details"]).to eq model.meet_details
    expect(attributes["name"]).to eq model.name
    expect(attributes["profile-picture-url"]).to eq model.profile_picture_url
    expect(attributes["short-description"]).to eq model.short_description
    expect(attributes["slug"]).to eq model.slug
    expect(attributes["target-audience"]).to eq model.target_audience
  end

  get "api/v1/groups" do
    let!(:groups) { create_list(:group, 3, :completed) }

    example_request "Listing groups" do
      expect(status).to eq 200
      expect_group(response["data"][0], groups[0])
      expect_group(response["data"][1], groups[1])
      expect_group(response["data"][2], groups[2])
    end
  end

  get "api/v1/groups/:id" do
    let(:group) { create(:group, :completed) }
    let(:id) { group.id }

    parameter :id, "The group id"

    example_request "Show a group" do
      expect(status).to eq 200
      expect_group(response["data"], group)
    end
  end

  get "api/v1/bulletins/:bulletin_id/group" do
    let(:bulletin) { create(:bulletin) }
    let(:bulletin_id) { bulletin.id }

    parameter :bulletin_id, "The bulletin to fetch the group for"

    example_request "Fetch the group of a bulletin" do
      expect(status).to eq 200
      expect_group(response["data"], bulletin.group)
    end
  end

  get "api/v1/groups/sign" do
    let(:directory) { "groups" }
    it_behaves_like "an endpoint that returns a signature to upload to s3"
  end
end
