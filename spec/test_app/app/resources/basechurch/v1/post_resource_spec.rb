require 'rails_helper'

RSpec.describe Basechurch::V1::PostResource, :type => :resource do
  let(:post) { create(:post) }
  let(:resource) { Basechurch::V1::PostResource.new(post) }
  let(:group_resource) { Basechurch::V1::GroupResource.new(post.group) }

  subject { resource }

  its(:id) { is_expected.to eq(post.id) }
  its(:content) { is_expected.to eq(post.content) }
  its(:published_at) { is_expected.to eq(post.published_at) }

  context "with a banner_url" do
    let(:post) { create(:post, banner_url: "http://example.com/test.png") }
    its(:banner_url) { is_expected.to eq(post.banner_url) }
  end

  describe "#group" do
    subject { resource.group.id }
    it { is_expected.to eq(group_resource.id) }
  end

  describe 'apply_filter' do
    let(:records) { Basechurch::Post.all }
    let(:group) { create(:group) }

    subject do
      Basechurch::V1::PostResource.apply_filter(records, filter, value)
    end

    context 'when filter is :group' do
      let(:filter) { :group }
      let(:value) { group.id.to_s }
      let(:posts) do
        create_list(:post, 3, group: group)
      end

      before do
        create(:post)
        posts
        create(:post)
      end

      it { is_expected.to eq(posts) }

      context 'with an invalid group id' do
        let (:value) { 'aasdfa' }

        it { is_expected.to eq([]) }
      end
    end
  end
end
