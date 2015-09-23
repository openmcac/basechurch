require 'rails_helper'

RSpec.describe V1::AnnouncementResource, :type => :resource do
  let(:group) { create(:group) }
  let(:bulletin) { create(:bulletin_with_announcements, group: group) }
  let(:records) { Announcement.all }
  let(:options) { {} }

  describe 'apply_filter' do
    context 'when filter is something else' do
      subject do
        V1::AnnouncementResource.apply_filter(records, filter, value, options)
      end

      let(:filter) { 'description' }
      let(:value) { 'whatever' }

      before { bulletin }

      it { is_expected.to eq([]) }
    end

    context 'when filter is :latest_for_group' do
      subject do
        V1::AnnouncementResource.apply_filter(records, filter, value, options)
      end

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

    context 'when filter is :defaults_for_bulletin' do
      subject do
        V1::AnnouncementResource.apply_filter(records, filter, value, options)
      end

      let(:filter) { :defaults_for_bulletin }
      let(:bulletin) do
        create(:bulletin_with_announcements,
               group: group,
               published_at: 1.day.ago)
      end
      let(:value) { bulletin.id.to_s }
      let(:previous_bulletin) do
        create(:bulletin_with_announcements,
               group: group,
               published_at: 3.days.ago)
      end

      before do
        create(:bulletin_with_announcements,
               group: group,
               published_at: 5.days.ago)

        previous_bulletin

        create(:bulletin_with_announcements, published_at: 2.days.ago)

        create(:bulletin_with_announcements,
               published_at: 4.days.ago,
               group: group)

        create(:bulletin_with_announcements,
               published_at: 5.days.ago,
               group: group)

        bulletin
      end

      it { is_expected.to eq(previous_bulletin.announcements) }
    end
  end
end
