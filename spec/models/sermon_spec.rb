require 'rails_helper'

RSpec.describe Sermon, :type => :model do
  describe 'validations' do
    it "has a valid default factory" do
      expect(create(:sermon)).to be_valid
    end

    it "requires a group" do
      expect(build(:sermon, group: nil)).not_to be_valid
    end

    it "requires a speaker" do
      expect(build(:sermon, speaker: nil)).not_to be_valid
    end

    it "requires a published_at" do
      expect(build(:sermon, published_at: nil)).not_to be_valid
    end
  end

  context '#tag_list' do
    let(:sermon) { create(:sermon) }

    it "can be tagged" do
      sermon.tag_list << "humility"
      sermon.save

      expect(sermon.tags.map(&:name)).to eq ["humility"]
    end
  end

  context "#audio" do
    let(:field) { "audio" }
    let(:factory_name) { :sermon }
    let(:class_name) { "Sermon" }
    let(:update_attributes) { {} }
    it_behaves_like "an attachment"
  end

  context "#banner" do
    let(:field) { "banner" }
    let(:factory_name) { :sermon }
    let(:class_name) { "Sermon" }
    let(:update_attributes) { {} }
    it_behaves_like "an attachment"
  end
end
