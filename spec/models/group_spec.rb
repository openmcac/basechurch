require 'rails_helper'

RSpec.describe Basechurch::Group, :type => :model do
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
