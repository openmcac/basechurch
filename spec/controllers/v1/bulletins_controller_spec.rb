require 'rails_helper'

describe V1::BulletinsController do
  describe 'GET /bulletins/:id' do
    let(:bulletin) { create(:bulletin) }

    it 'returns a single bulletin' do
      get :show, id: bulletin.id
      expect(response.body).to eq(BulletinSerializer.new(bulletin).to_json)
    end
  end
end

