require 'rails_helper'

describe Basechurch::V1::GroupsController, type: :controller do
  describe 'GET /groups/:id' do
    let(:group) do
      create(:group, created_at: DateTime.iso8601('2001-02-03T04:05:06+07:00'))
    end

    it 'returns a single group' do
      get :show, id: group.id
      body = JSON.parse(response.body)
      expect(body['groups']['id']).to eq(group.id.to_s)
      expect(body['groups']['name']).to eq(group.name)
      expect(body['groups']['slug']).to eq(group.slug)
      expect(body['groups']['createdAt']).to eq('2001-02-02T21:05:06Z')
    end
  end
end
