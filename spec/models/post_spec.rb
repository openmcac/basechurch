require 'rails_helper'

RSpec.describe Post, :type => :model do
  context 'validations' do
    it 'requires content' do
      expect(build(:post, content: '')).to_not be_valid
    end

    it 'requires an author' do
      expect(build(:post, author: nil)).to_not be_valid
    end

    context 'when updating a post' do
      it 'requires an editor' do
        expect(create(:post)).not_to be_valid
      end
    end
  end
end
