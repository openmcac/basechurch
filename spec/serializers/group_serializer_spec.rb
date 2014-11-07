require 'rails_helper'
require 'rspec/its'

describe GroupSerializer do
  let(:group) { create(:group) }
  let(:group_json) { JSON.parse(GroupSerializer.new(group).to_json) }
  subject { group_json['group'] }

  it 'has a "group" root element' do
    expect(group_json).to have_key('group')
  end

  its(['name']) { should eq(group.name) }
  its(['createdAt']) { should eq(group.created_at.utc.to_time.iso8601) }
end
