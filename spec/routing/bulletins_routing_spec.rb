require 'rails_helper'

describe 'routes for bulletins', type: :routing do
  describe 'GET /v1/bulletins/:id' do
    let(:id) { 1 }
    let(:show_bulletin) { get "/v1/bulletins/#{id}" }

    it 'routes to bulletins#show(id)' do
      expect(show_bulletin).to route_to(controller: 'v1/bulletins',
                                        action: 'show',
                                        id: '1',
                                        format: 'json')
    end
  end

  describe 'GET /v1/sunday' do
    let(:show_sunday_bulletin) { get '/v1/sunday' }

    it 'routes to bulletins#sunday' do
      expect(show_sunday_bulletin).
          to route_to(controller: 'v1/bulletins',
                      action: 'sunday',
                      format: 'json')
    end
  end

  describe 'POST /v1/bulletins' do
    let(:id) { 1 }
    let(:post_bulletin) { post "/v1/bulletins" }

    it 'routes to bulletins#create)' do
      expect(post_bulletin).to route_to(controller: 'v1/bulletins',
                                        action: 'create',
                                        format: 'json')
    end
  end

  describe "GET /v1/bulletins/sign" do
    let(:sign) { get "/v1/bulletins/sign" }

    it "routes to bulletins#sign)" do
      expect(sign).to route_to(controller: "v1/bulletins",
                               action: "sign",
                               format: "json")
    end
  end
end

