require 'rails_helper'

RSpec.describe Basechurch::Post, :type => :model do
  shared_examples_for "an optional url" do
    it "requires a valid url" do
      expect(build(:post, key => "hello_COD")).to_not be_valid
      expect(build(:post, key => "http://something.com")).to be_valid
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

    context "with a banner url" do
      let(:key) { :banner_url }
      it_behaves_like "an optional url"
    end

    context "with a banner" do
      let(:post) { create(:post) }
      let!(:banner) do
        create(:attachment,
               element_id: post.id,
               element_type: "Basechurch::Post",
               element_key: "banner")
      end

      it "has a banner" do
        expect(post.banner).to eq banner
      end
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
    let(:published_at) { DateTime.now }
    let(:post) do
      create(:post, display_published_at: published_at.iso8601)
    end

    it 'populates #published_at with a DateTime equivalent' do
      expect(post.published_at.to_i).to eq(published_at.to_i)
    end
  end

  context "#after_save" do
    let(:banner_url) { "http://test.com/example.png" }
    let(:post) { create(:post, banner_url: banner_url) }

    it "saves an attachment from the banner_url provided" do
      expect(post.banner.url).to eq banner_url
    end

    context "when updating the banner url" do
      it "updates the banner object" do
        banner_id = post.banner.id
        post.banner_url = "http://test.com/new.png"
        post.editor = create(:user)
        post.save!

        expect(post.banner.id).to eq banner_id
        expect(post.banner.url).to eq "http://test.com/new.png"
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
