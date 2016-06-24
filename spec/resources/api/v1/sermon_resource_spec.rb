require 'rails_helper'

RSpec.describe Api::V1::SermonResource, type: :resource do
  let(:sermon) do
    create(:sermon,
           banner_url: "http://#{Forgery("internet").domain_name}/profile.jpg",
           audio_url: "http://#{Forgery("internet").domain_name}/profile.mp3")
  end
  let(:records) { Sermon.all }

  subject { Api::V1::SermonResource.new(sermon, nil) }

  its(:audio_url) { is_expected.to eq(sermon.audio_url) }
  its(:banner_url) { is_expected.to eq(sermon.banner_url) }
  its(:id) { is_expected.to eq(sermon.id) }
  its(:name) { is_expected.to eq(sermon.name) }
  its(:notes) { is_expected.to eq(sermon.notes) }
  its(:series) { is_expected.to eq(sermon.series) }
  its(:speaker) { is_expected.to eq(sermon.speaker) }
end
