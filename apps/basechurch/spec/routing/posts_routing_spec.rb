require "rails_helper"

describe "routes for posts", type: :routing do
  describe "GET /api/v1/posts/sign" do
    let(:sign) { get "/api/v1/posts/sign" }

    it "routes to posts#sign" do
      expect(sign).to route_to(controller: "api/v1/posts",
                               action: "sign",
                               format: "json")
    end
  end
end
