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

  describe "pagination" do
    let(:group) { create(:group) }
    let!(:bulletins) do
      [
        create(:bulletin, group: group, published_at: DateTime.now - 20.days),
        create(:bulletin, group: group, published_at: DateTime.now - 10.days),
        create(:bulletin, group: group, published_at: DateTime.now - 5.day)
      ]
    end
    
    before do
      create(:bulletin, published_at: DateTime.now - 11.days)
      create(:bulletin, published_at: DateTime.now - 6.days)
      create(:bulletin, group: group, published_at: 5.days.from_now)
    end

    describe ".next" do
      it "returns the next bulletin" do
        expect(Bulletin.next(bulletins.second)).to eq bulletins.last
      end

      context "when the bulletin hasn't been published yet" do
        subject do
          b = create(:bulletin, group: group, published_at: 5.days.from_now)
          Bulletin.next(b, options)
        end

        let(:options) { {} }

        it { is_expected.to be_nil }

        context "with rollover = true" do
          let(:options) { { rollover: true } }

          it "rolls over to the first published bulletin" do
            expect(subject).to eq bulletins.first
          end
        end
      end

      context "when at the latest bulletin" do
        subject { Bulletin.next(bulletins.last, options) }

        let(:options) { {} }

        it { is_expected.to be_nil }

        context "with rollover = true" do
          let(:options) { { rollover: true } }

          it "rolls over to the first published bulletin" do
            expect(subject).to eq bulletins.first
          end
        end
      end
    end

    describe ".previous" do
      it "returns the previous bulletin" do
        expect(Bulletin.previous(bulletins.second)).to eq bulletins.first
      end

      context "when the bulletin hasn't been published yet" do
        subject do
          b = create(:bulletin, group: group, published_at: 5.days.from_now)
          Bulletin.previous(b, options)
        end

        let(:options) { {} }

        it { is_expected.to be_nil }

        context "with rollover = true" do
          let(:options) { { rollover: true } }

          it "rolls over to the last published bulletin" do
            expect(subject).to eq bulletins.last
          end
        end
      end

      context "when at the earliest bulletin" do
        subject { Bulletin.previous(bulletins.first, options) }

        let(:options) { {} }

        it { is_expected.to be_nil }

        context "with rollover = true" do
          let(:options) { { rollover: true } }

          it "rolls over to the last published bulletin" do
            expect(subject).to eq bulletins.last
          end
        end
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

  describe "#sermon" do
    let(:sermon) { build(:sermon) }

    it "can be associated to a sermon" do
      expect(build(:bulletin, sermon: sermon).sermon).to eq sermon
    end
  end

  context "#banner" do
    let(:field) { "banner" }
    let(:factory_name) { :bulletin }
    let(:class_name) { "Bulletin" }
    let(:update_attributes) { {} }
    it_behaves_like "an attachment"
  end
end
