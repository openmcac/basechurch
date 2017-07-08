require 'rails_helper'

RSpec.describe Api::V1::PostResource, type: :resource do
  let(:post) { create(:post ) }
  let(:resource) { Api::V1::PostResource.new(post, nil) }
  let(:group_resource) { Api::V1::GroupResource.new(post.group, nil) }

  subject { resource }

  before do
    post.tag_list.add("tag1")
    post.tag_list.add("tag2")
  end

  its(:id) { is_expected.to eq(post.id) }
  its(:content) { is_expected.to eq(post.content) }
  its(:published_at) { is_expected.to eq(post.published_at) }
  its(:group_slug) { is_expected.to eq(post.group.slug) }

  context "with a banner_url" do
    let(:post) { create(:post, banner_url: "http://example.com/test.png") }
    its(:banner_url) { is_expected.to eq(post.banner_url) }
  end

  describe "#group" do
    subject { resource.group.id }
    it { is_expected.to eq(group_resource.id) }
  end

  describe 'apply_filter' do
    let(:records) { Post.all }
    let(:group) { create(:group) }
    let(:options) { {} }

    subject do
      Api::V1::PostResource.apply_filter(records, filter, value, options)
    end

    context "when filter is :status" do
      let(:filter) { :status }
      let(:value) { [] }
      let!(:posts) do
        create_list(:post, 3, group: group)
      end
      let!(:postdated_post) { create(:post, published_at: 1.day.from_now) }

      it { is_expected.to eq([post] + posts) }

      context 'with the "all" filter' do
        let (:value) { ["all"] }

        it { is_expected.to eq([post] + posts + [postdated_post]) }
      end
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
