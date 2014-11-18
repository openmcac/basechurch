require 'rails_helper'
require 'rspec/its'

describe GroupSerializer do
  let(:group) { create(:group) }
  let(:group_json) { JSON.parse(GroupSerializer.new(group).to_json) }

  it_behaves_like 'a serialized group'
end
