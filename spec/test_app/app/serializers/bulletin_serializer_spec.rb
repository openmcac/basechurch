require 'rails_helper'
require 'rspec/its'

describe BulletinSerializer do
  let(:bulletin) { create(:bulletin_with_announcements) }
  let(:bulletin_json) { JSON.parse(BulletinSerializer.new(bulletin).to_json) }

  subject { bulletin_json['bulletin'] }

  it 'has a "bulletin" root element' do
    expect(bulletin_json).to have_key('bulletin')
  end

  its(['name']) { should eq(bulletin.name) }
  its(['serviceOrder']) { should eq(bulletin.service_order) }
  its(['description']) { should eq(bulletin.description) }
  its(['publishedAt']) { should eq(bulletin.published_at.utc.to_time.iso8601) }
  its(['description']) { should eq(bulletin.description) }

  context 'with a group' do
    let(:group) { bulletin.group }
    let(:group_json) { bulletin_json['bulletin'] }
    it_behaves_like 'a serialized group'
  end

  context 'with announcements' do
    it 'has an "announcements" key' do
      expect(bulletin_json['bulletin']).to have_key('announcements')
    end

    it "serializes the announcements' descriptions" do
      expect(bulletin_json['bulletin']['announcements'][0]['description']).
          to eq(bulletin.announcements[0].description)
      expect(bulletin_json['bulletin']['announcements'][1]['description']).
          to eq(bulletin.announcements[1].description)
      expect(bulletin_json['bulletin']['announcements'][2]['description']).
          to eq(bulletin.announcements[2].description)
    end
  end
end
