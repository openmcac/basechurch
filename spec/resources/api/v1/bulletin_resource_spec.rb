require 'rails_helper'

RSpec.describe Api::V1::BulletinResource, type: :resource do
  let(:bulletin) do
    create(:bulletin_with_announcements,
           banner_url: "http://banner.com",
           audio_url: "http://audio.com",
           sermon_notes: "these are sermon notes")
  end
  let(:resource) { Api::V1::BulletinResource.new(bulletin, nil) }
  let(:group_resource) { Api::V1::GroupResource.new(bulletin.group, nil) }

  subject { resource }

  its(:audio_url) { is_expected.to eq(bulletin.audio_url) }
  its(:banner_url) { is_expected.to eq(bulletin.banner_url) }
  its(:description) { is_expected.to eq(bulletin.description) }
  its(:id) { is_expected.to eq(bulletin.id) }
  its(:name) { is_expected.to eq(bulletin.name) }
  its(:published_at) { is_expected.to eq(bulletin.published_at) }
  its(:sermon_notes) { is_expected.to eq(bulletin.sermon_notes) }
  its(:service_order) { is_expected.to eq(bulletin.service_order) }

  describe "#group" do
    subject { resource.group.id }
    it { is_expected.to eq(group_resource.id) }
  end

  describe 'apply_filter' do
    let(:records) { Bulletin.all }
    let(:group) { create(:group) }
    let(:options) { {} }

    subject do
      Api::V1::BulletinResource.apply_filter(records, filter, value, options)
    end

    context 'when filter is something else' do
      let(:filter) { 'description' }
      let(:value) { 'whatever' }

      it { is_expected.to eq([]) }
    end

    context 'when filter is :group' do
      let(:filter) { :group }
      let(:value) { group.id.to_s }
      let(:bulletins) do
        create_list(:bulletin, 3, group: group)
      end

      before do
        create(:bulletin)
        bulletins
        create(:bulletin)
      end

      it { is_expected.to eq(bulletins) }

      context 'with an invalid group id' do
        let (:value) { 'aasdfa' }

        it { is_expected.to eq([]) }
      end
    end

    context 'when filter is :latest_for_group' do
      let(:filter) { :latest_for_group }
      let(:value) { latest_bulletin.group.id.to_s }
      let(:latest_bulletin) do
        create(:bulletin, group: group, published_at: DateTime.now)
      end

      before do
        create(:bulletin, group: group, published_at: 1.day.ago)
        latest_bulletin
        create(:bulletin)
        create(:bulletin, group: group, published_at: 2.day.ago)
      end

      it { is_expected.to eq([latest_bulletin]) }

      context 'with an invalid group id' do
        let (:value) { 'aasdfa' }

        it { is_expected.to eq([]) }
      end
    end
  end
end
