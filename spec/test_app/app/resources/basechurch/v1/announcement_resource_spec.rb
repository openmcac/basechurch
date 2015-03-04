require 'rails_helper'

RSpec.describe Basechurch::V1::AnnouncementResource, :type => :resource do
  let(:group) { create(:group) }
  let(:bulletin) { create(:bulletin_with_announcements, group: group) }
  let(:records) { Basechurch::Announcement.all }

  describe 'apply_filter' do
    subject do
      Basechurch::V1::AnnouncementResource.apply_filter(records, filter, value)
    end

    context 'when filter is something else' do
      let(:filter) { 'description' }
      let(:value) { 'whatever' }

      before { bulletin }

      it { is_expected.to eq([]) }
    end

    context 'when filter is :latest_for_group' do
      let(:filter) { :latest_for_group }
      let(:value) { group.id.to_s }

      before { bulletin }

      it { is_expected.to eq(bulletin.announcements) }

      context 'with an invalid group id' do
        let (:value) { 'aasdfa' }

        it 'raises an Argument error' do
          expect{ subject }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
