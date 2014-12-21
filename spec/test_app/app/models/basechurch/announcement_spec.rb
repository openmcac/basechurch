require 'rails_helper'

RSpec.describe Basechurch::Announcement, :type => :model do
  describe 'validations' do
    context 'with valid params' do
      it 'is valid' do
        expect(build(:announcement)).to be_valid
      end
    end

    context 'with invalid params' do
      it 'requires a description' do
        expect(build(:announcement, description: '')).to_not be_valid
      end

      it 'requires a post' do
        expect(build(:announcement, post: nil)).to_not be_valid
      end

      it 'requires a bulletin' do
        expect(build(:announcement, bulletin: nil)).to_not be_valid
      end
    end
  end
end
