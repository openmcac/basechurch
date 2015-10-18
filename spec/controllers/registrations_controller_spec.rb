require "rails_helper"

describe RegistrationsController, type: :controller do
  describe "#create" do
    let(:perform_action) do
      post :create,
           email: email,
           password: "password",
           password_confirmation: "password"
    end

    let(:user) { User.last }
    let(:email) { "test@example.com" }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it "creates a new user" do
      expect { perform_action }.to change { User.count }.by(1)
      expect(user.email).to eq email
    end
  end
end
