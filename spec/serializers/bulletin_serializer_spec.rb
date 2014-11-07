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
  its(['date']) { should eq(bulletin.date.utc.to_time.iso8601) }
  its(['description']) { should eq(bulletin.description) }
end

