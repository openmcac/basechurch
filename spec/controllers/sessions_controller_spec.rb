require "rails_helper"

describe SessionsController, type: :controller do
  describe "#create" do
    let!(:user) { create(:user, password: "randompw", provider: "email") }
    let(:data) { JSON.parse(response.body)["data"] }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, email: user.email, password: user.password
    end

    it "returns the logged user" do
      expect(data["id"]).to eq user.id.to_s
      expect(data["attributes"]["email"]).to eq user.email
      expect(data["attributes"]["name"]).to eq user.name
    end
  end
end
