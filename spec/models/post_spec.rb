require 'rails_helper'

RSpec.describe Post, :type => :model do
  context 'validations' do
    it 'requires content' do
      expect(build(:post, content: '')).to_not be_valid
    end

    it 'requires an author' do
      expect(build(:post, author: nil)).to_not be_valid
    end

    it 'requires a valid publish date' do
      expect(build(:post, display_published_at: 'asdfasdfasd')).to_not be_valid
    end

    context 'when updating a post' do
      it 'requires an editor' do
        expect(create(:post)).not_to be_valid
      end
    end
  end

  context '#before_save' do
    let(:published_at) { DateTime.now }
    let(:post) do
      create(:post, display_published_at: published_at.iso8601)
    end

    it 'populates #published_at with a DateTime equivalent' do
      expect(post.published_at.to_i).to eq(published_at.to_i)
    end
  end
end
