require 'rails_helper'
require 'rspec/its'

describe AnnouncementSerializer do
  let(:announcement) { create(:announcement) }
  let(:announcement_json) do
    JSON.parse(AnnouncementSerializer.new(announcement).to_json)
  end

  it_behaves_like 'a serialized announcement'
end
