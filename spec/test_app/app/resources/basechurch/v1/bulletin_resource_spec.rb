require 'rails_helper'

RSpec.describe Basechurch::V1::BulletinResource, :type => :resource do
  let(:bulletin) { create(:bulletin, banner_url: "http://something.com") }
  let(:resource) { Basechurch::V1::BulletinResource.new(bulletin) }
  let(:group_resource) { Basechurch::V1::GroupResource.new(bulletin.group) }

  subject { resource }

  its(:id) { is_expected.to eq(bulletin.id) }
  its(:description) { is_expected.to eq(bulletin.description) }
  its(:name) { is_expected.to eq(bulletin.name) }
  its(:published_at) { is_expected.to eq(bulletin.published_at) }
  its(:service_order) { is_expected.to eq(bulletin.service_order) }
  its(:banner_url) { is_expected.to eq(bulletin.banner_url) }


  describe "#group" do
    subject { resource.group.id }
    it { is_expected.to eq(group_resource.id) }
  end

  describe 'apply_filter' do
    let(:records) { Basechurch::Bulletin.all }
    let(:group) { create(:group) }

    subject do
      Basechurch::V1::BulletinResource.apply_filter(records, filter, value)
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

