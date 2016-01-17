require 'rails_helper'

RSpec.describe Bulletin, type: :model do
  context 'scopes' do
    describe ".for_group" do
      let(:group) { create(:group) }
      let!(:bulletins) { create_list(:bulletin, 3, group: group) }

      before { create(:bulletin) }

      it "returns the bulletins for a given group" do
        expect(Bulletin.for_group(group.id)).to eq bulletins
      end
    end

    context "english service bulletins" do
      let!(:group) { create('group', name: 'English Service', id: 1) }
      let!(:bulletins) { create_list('bulletin', 3, group: group) }

      before { create_list('bulletin', 3) }

      it 'returns the english service bulletins' do
        expect(Bulletin.english_service.all).to eq(bulletins)
      end
    end

    describe 'latest' do
      let(:latest_bulletins) do
        [create('bulletin', published_at: 1.months.ago),
         create('bulletin', published_at: 2.months.ago),
         create('bulletin', published_at: 3.months.ago)]
      end

      before do
        create('bulletin', published_at: 3.months.from_now)
        latest_bulletins
      end

      it 'returns the most recently published bulletin' do
        expect(Bulletin.latest).to eq(latest_bulletins)
      end
    end
  end

  describe ".previous" do
    let!(:bulletin) { create(:bulletin, published_at: published_at) }
    let(:published_at) { 1.year.ago }

    context "when there is a previous bulletin" do
      let!(:previous_bulletin) do
        create(:bulletin, published_at: published_at - 5.days, group: bulletin.group)
      end

      before do
        # older than previous_bulletin
        create(:bulletin,
               published_at: published_at - 6.days,
               group: bulletin.group)

        # would be the previous bulletin, but belongs to different group
        create(:bulletin, published_at: published_at - 4.days)
      end

      it "returns the previous bulletin" do
        expect(Bulletin.previous(bulletin)).to eq previous_bulletin
      end
    end

    context "when there is no previous bulletin" do
      it "returns nil" do
        expect(Bulletin.previous(bulletin)).to be_nil
      end
    end
  end

  describe ".next" do
    let!(:bulletin) { create(:bulletin, published_at: published_at) }
    let!(:next_bulletin) do
      create(:bulletin, published_at: published_at + 5.days, group: bulletin.group)
    end

    context "when the next bulletin has been published" do
      let(:published_at) { 1.year.ago }
 
      before do
        # later than next_bulletin
        create(:bulletin,
               published_at: published_at + 6.days,
               group: bulletin.group)

        # would be the next bulletin, but belongs to different group
        create(:bulletin, published_at: published_at + 4.days)
      end

      it "returns the next bulletin" do
        expect(Bulletin.next(bulletin)).to eq next_bulletin
      end
    end

    context "when the current bulletin has not been published" do
      let(:published_at) { 10.days.from_now }

      it "returns nil" do
        expect(Bulletin.next(bulletin)).to be_nil
      end
    end

    context "when the next bulletin has not been published" do
      let(:published_at) { 1.second.ago }

      it "returns nil" do
        expect(Bulletin.next(bulletin)).to be_nil
      end
    end
  end

  context "validation" do
    it "has a valid default factory" do
      expect(build(:bulletin)).to be_valid
    end

    it 'requires a valid date' do
      expect(build(:bulletin, published_at: '')).to_not be_valid
    end

    it 'requires a group' do
      expect(build(:bulletin, group: nil)).to_not be_valid
    end
  end

  describe "#published?" do
    context "when the bulletin is published in the future" do
      it "returns false" do
        expect(build(:bulletin, published_at: 3.days.from_now)).
          not_to be_published
      end
    end

    context "when the bulletin is published in the past" do
      it "returns true" do
        expect(build(:bulletin, published_at: 3.days.ago)).to be_published
      end
    end
  end

  context "#banner" do
    let(:field) { "banner" }
    let(:factory_name) { :bulletin }
    let(:class_name) { "Bulletin" }
    let(:update_attributes) { {} }
    it_behaves_like "an attachment"
  end

  context "#audio" do
    let(:field) { "audio" }
    let(:factory_name) { :bulletin }
    let(:class_name) { "Bulletin" }
    let(:update_attributes) { {} }
    it_behaves_like "an attachment"
  end
end
