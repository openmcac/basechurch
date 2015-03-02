require 'rails_helper'

describe 'routes for announcements', type: :routing do
  routes { Basechurch::Engine.routes }

  describe 'POST /v1/announcements' do
    let(:id) { 1 }
    let(:post_announcement) { post "/v1/announcements" }

    it 'routes to announcements#create)' do
      expect(post_announcement).to route_to(controller: 'basechurch/v1/announcements',
                                            action: 'create',
                                            format: 'json')
    end
  end
end
