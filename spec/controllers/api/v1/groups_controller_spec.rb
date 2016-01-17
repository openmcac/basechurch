require 'rails_helper'

describe Api::V1::GroupsController, type: :controller do
  let(:user) { create(:user) }
  let(:group) do
    create(:group,
           created_at: DateTime.iso8601("2001-02-03T04:05:06+07:00"),
           about: Forgery(:lorem_ipsum).text,
           banner_url: "http://#{Forgery(:internet).domain_name}")
  end

  shared_examples_for "a group payload" do
    it 'returns a single group' do
      data = JSON.parse(response.body)["data"]
      attributes = data["attributes"]
      expect(data["id"]).to eq group.id.to_s
      expect(data["type"]).to eq "groups"
      expect(attributes["name"]).to eq group.name
      expect(attributes["slug"]).to eq group.slug
      expect(attributes["about"]).to eq group.about
      expect(attributes["banner-url"]).to eq group.banner_url
      expect(attributes["created-at"]).to eq "2001-02-02T21:05:06+00:00"
    end
  end

  describe 'GET /groups/:id' do
    before { get :show, id: group.id }

    it_behaves_like "a group payload"
  end

  describe "GET /bulletins/:bulletin_id/group" do
    let(:bulletin) { create(:bulletin, group: group) }

    before do
      get :get_related_resource,
        bulletin_id: bulletin.id,
        relationship: "group",
        source: "api/v1/bulletins"
    end

    it_behaves_like "a group payload"
  end

  describe "s3 signing" do
    let(:directory) { "groups" }
    it_behaves_like "a request that returns a signature to upload to s3"
  end
end
