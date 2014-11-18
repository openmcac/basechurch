require 'rails_helper'
require 'rspec/its'

describe BulletinSerializer do
  let(:bulletin) { create(:bulletin) }
  let(:bulletin_json) { JSON.parse(BulletinSerializer.new(bulletin).to_json) }

  subject { bulletin_json['bulletin'] }

  it 'has a "bulletin" root element' do
    expect(bulletin_json).to have_key('bulletin')
  end

  its(['name']) { should eq(bulletin.name) }
  its(['serviceOrder']) { should eq(bulletin.service_order) }
  its(['publishedAt']) { should eq(bulletin.published_at.utc.to_time.iso8601) }
  its(['description']) { should eq(bulletin.description) }

  context 'with a group' do
    let(:group) { bulletin.group }
    let(:group_json) { JSON.parse(GroupSerializer.new(group).to_json) }
    it_behaves_like 'a serialized group'
  end
end

