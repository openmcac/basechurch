require 'rails_helper'

RSpec.describe Basechurch::Bulletin, :type => :model do
  context 'scopes' do
    context "english service bulletins" do
      let!(:group) { create('group', name: 'English Service', id: 1) }
      let!(:bulletins) { create_list('bulletin', 3, group: group) }

      before { create_list('bulletin', 3) }

      it 'returns the english service bulletins' do
        expect(Basechurch::Bulletin.english_service.all).to eq(bulletins)
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
        expect(Basechurch::Bulletin.latest).to eq(latest_bulletins)
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

  context "#banner" do
    let(:field) { "banner" }
    let(:factory_name) { :bulletin }
    let(:class_name) { "Basechurch::Bulletin" }
    let(:update_attributes) { {} }
    it_behaves_like "an attachment"
  end

  context "#audio" do
    let(:field) { "audio" }
    let(:factory_name) { :bulletin }
    let(:class_name) { "Basechurch::Bulletin" }
    let(:update_attributes) { {} }
    it_behaves_like "an attachment"
  end
end
