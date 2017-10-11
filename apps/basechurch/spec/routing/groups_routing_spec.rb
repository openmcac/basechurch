require "rails_helper"

describe "routes for groups", type: :routing do
  describe "GET /api/v1/groups/sign" do
    let(:sign) { get "/api/v1/groups/sign" }

    it "routes to groups#sign" do
      expect(sign).to route_to(controller: "api/v1/groups",
                               action: "sign",
                               format: "json")
    end
  end
end

