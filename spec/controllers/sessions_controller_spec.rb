require "rails_helper"

describe SessionsController, type: :controller do
  before do
    request.headers["Content-Type"] = "application/vnd.api+json"
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "#create" do
    let(:user) { create(:user, password: pw) }
    let(:pw) { "mypassword" }
    let(:payload) { JSON.parse(response.body) }

    before do
      post :create, user: { email: user.email, password: pw }
    end

    it "returns the logged in user's payload" do
      data = payload["data"]
      expect(data["id"]).to eq user.id.to_s
      expect(data["attributes"]["name"]).to eq user.name
      expect(data["attributes"]["email"]).to eq user.email
      expect(data["attributes"]["api-key"]).to eq user.session_api_key.access_token
    end
  end
end
