require 'rails_helper'

describe 'routes for bulletins', type: :routing do
  routes { Basechurch::Engine.routes }

  describe 'GET /v1/bulletins/:id' do
    let(:id) { 1 }
    let(:show_bulletin) { get "/v1/bulletins/#{id}" }

    it 'routes to bulletins#show(id)' do
      expect(show_bulletin).to route_to(controller: 'basechurch/v1/bulletins',
                                        action: 'show',
                                        id: '1',
                                        format: 'json')
    end
  end

  describe 'POST /v1/bulletins' do
    let(:id) { 1 }
    let(:post_bulletin) { post "/v1/bulletins" }

    it 'routes to bulletins#create)' do
      expect(post_bulletin).to route_to(controller: 'basechurch/v1/bulletins',
                                        action: 'create',
                                        format: 'json')
    end
  end
end

