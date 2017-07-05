require 'rails_helper'

RSpec.describe Group, :type => :model do
  describe 'validations' do
    it 'requires a name' do
      expect(build(:group, name: '')).to_not be_valid
    end

    it 'requires a valid slug' do
      expect(build(:group, slug: 'bad_slug')).to_not be_valid
    end

    context 'where the slug already exists' do
      let!(:existing_group) { create(:group) }

      it 'requires a unique slug' do
        expect(build(:group, slug: existing_group.slug)).to_not be_valid
      end
    end

    it "requires a short description" do
      expect(build(:group, short_description: '')).to_not be_valid
    end

    it "requires short description to be less than 140 characters" do
      group = build(:group,
                    short_description: Forgery('lorem_ipsum').characters(141))
      expect(group).not_to be_valid
    end

    it "requires a meet details" do
      expect(build(:group, meet_details: '')).to_not be_valid
    end

    it "requires meet details to be less than 50 characters" do
      group = build(:group,
                    meet_details: Forgery('lorem_ipsum').characters(51))
      expect(group).not_to be_valid
    end

    it "requires a target audience" do
      expect(build(:group, target_audience: '')).to_not be_valid
    end

    it "requires target audience to be less than 50 characters" do
      group = build(:group,
                    target_audience: Forgery('lorem_ipsum').characters(51))
      expect(group).not_to be_valid
    end
  end

  context "#banner" do
    let(:field) { "banner" }
    let(:factory_name) { :group }
    let(:class_name) { "Group" }
    let(:update_attributes) { {} }
    it_behaves_like "an attachment"
  end

  context "#profile_picture" do
    let(:field) { "profile_picture" }
    let(:factory_name) { :group }
    let(:class_name) { "Group" }
    let(:update_attributes) { {} }
    it_behaves_like "an attachment"
  end

  describe '#slug' do
    context 'with a custom slug' do
      let(:custom_slug) { 'custom-slug' }

      let(:group) { create(:group, name: 'Group Name', slug: custom_slug) }

      it 'uses the custom slug provided' do
        expect(group.slug).to eq(custom_slug)
      end
    end

    context 'without a custom slug' do
      let(:group) { create(:group, name: 'Group Name') }

      it 'populates a slug based on the group name' do
        expect(group.slug).to eq('group-name')
      end
    end
  end
end
