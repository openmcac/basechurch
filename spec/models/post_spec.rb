require 'rails_helper'

RSpec.describe Post, type: :model do
  context "#banner" do
    let(:field) { "banner" }
    let(:factory_name) { :post }
    let(:class_name) { "Post" }
    let(:update_attributes) { { editor: create(:user) } }
    it_behaves_like "an attachment"
  end

  context "#post?" do
    it "is a post by default" do
      expect(create(:post)).to be_post
    end

    context "when the post is a page" do
      subject { create(:post, kind: :page) }

      it { is_expected.not_to be_post }
    end
  end

  context "#page?" do
    context "when the post is a page" do
      subject { create(:post, kind: :page) }

      it { is_expected.to be_page }
    end

    context "when the post is not a page" do
      subject { create(:post) }

      it { is_expected.not_to be_page }
    end
  end

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

    it 'requires a group' do
      expect(build(:post, group: nil)).to_not be_valid
    end

    context 'when updating a post' do
      it 'requires an editor' do
        expect(create(:post)).not_to be_valid
      end

      context 'when a display_published_at value is not provided' do
        let(:post) { create(:post) }

        it 'assigns now as the published_at value' do
          Timecop.freeze do
            expect(post.published_at).to eq(DateTime.now)
          end
        end
      end
    end
  end

  context '#before_save' do
    context "with a display_published_at" do
      let(:published_at) { DateTime.new(2015, 1, 2) }
      let(:post) do
        create(:post, display_published_at: published_at.iso8601)
      end
      
      it 'populates #published_at with a DateTime equivalent' do
        expect(post.published_at.to_i).to eq(published_at.to_i)
      end
    end

    context "without a #display_published_at" do
      let(:post) do
        create(:post, display_published_at: "")
      end

      it "sets #published_at to the current time" do
        expect(post.published_at).to be_within(1.second).of DateTime.now
      end

      context "when it already has a published_at set" do
        let(:published_at) { DateTime.new(2000, 2, 3) }

        let(:post) do
          create(:post, published_at: published_at)
        end

        before do
          post.editor = create(:user)
        end

        it "doesn't update published_at" do
          expect { post.save! }.not_to change { post.published_at } 
        end
      end
    end
  end

  context '#slug' do
    context 'with a title' do
      context 'where it is <= 10 words' do
        let(:post) { create(:post, title: 'A nice title') }

        it 'populates a slug based on the title' do
          expect(post.slug).to eq('a-nice-title')
        end
      end

      context 'where it is longer than 10 words' do
        let(:post) do
          create(:post,
                 title: 'oh man this is a long word when will it truncate?')
        end

        it 'populates a slug based on the title' do
          expect(post.slug).
              to eq('oh-man-this-is-a-long-word-when-will-it')
        end
      end
    end

    context 'without a title' do
      context 'with content longer than 10 words' do
        let(:post) do
          create(:post,
                 content: 'oh man this is a long word when will it truncate?')
        end

        it 'populates a slug based on first 10 words of content' do
          expect(post.slug).
              to eq('oh-man-this-is-a-long-word-when-will-it')
        end
      end

      context 'with content <= 10 words' do
        let(:post) { create(:post, content: 'this is long') }

        it 'populates a slug based on content' do
          expect(post.slug).to eq('this-is-long')
        end
      end
    end
  end
end
