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

  describe 'PATCH /v1/announcements/:id/move/:position' do
    let(:id) { '1' }
    let(:position) { '10' }
    let(:patch_move_announcement) do
      patch "/v1/announcements/#{id}/move/#{position}"
    end

    it 'routes to announcements#move' do
      expect(patch_move_announcement).
          to route_to(controller: 'basechurch/v1/announcements',
                      action: 'move',
                      position: position,
                      id: id,
                      format: 'json')
    end
  end

  describe 'POST /v1/bulletins/:bulletin_id/announcements/add/:position' do
    let(:bulletin_id) { '1' }
    let(:position) { '10' }
    let(:post_announcement_at_position) do
      post "/v1/bulletins/#{bulletin_id}/announcements/add/#{position}"
    end

    it 'routes to announcements#create_at' do
      expect(post_announcement_at_position).
          to route_to(controller: 'basechurch/v1/announcements',
                      action: 'create_at',
                      position: position,
                      bulletin_id: bulletin_id,
                      format: 'json')
    end
  end
end
