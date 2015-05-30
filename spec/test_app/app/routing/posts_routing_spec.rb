require 'rails_helper'

describe 'routes for posts', type: :routing do
  routes { Basechurch::Engine.routes }

  describe "GET /v1/posts/sign" do
    let(:sign) { get "/v1/posts/sign" }

    it "routes to posts#sign" do
      expect(sign).to route_to(controller: "basechurch/v1/posts",
                               action: "sign",
                               format: "json")
    end
  end
end
