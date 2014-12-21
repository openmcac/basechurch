require 'rails_helper'

describe Basechurch::V1::GroupsController, type: :controller do
  describe 'GET /groups/:id' do
    let(:group) { create(:group) }

    it 'returns a single group' do
      get :show, id: group.id
      expect(response.body).to eq(GroupSerializer.new(group).to_json)
    end
  end
end