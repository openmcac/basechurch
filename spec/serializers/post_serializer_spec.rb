require 'rails_helper'
require 'rspec/its'

describe PostSerializer do
  let(:post) { create(:post) }
  let(:post_json) { JSON.parse(PostSerializer.new(post).to_json) }

  subject { post_json['post'] }

  it 'has a "post" root element' do
    expect(post_json).to have_key('post')
  end

  its(['id']) { should eq(post.id) }
  its(['title']) { should eq(post.title) }
  its(['content']) { should eq(post.content) }
  its(['slug']) { should eq(post.slug) }
  its(['editor']) { should be_nil }
  its(['createdAt']) { should eq(post.created_at.utc.to_time.iso8601) }
  its(['updatedAt']) { should eq(post.updated_at.utc.to_time.iso8601) }
  its(['publishedAt']) { should eq(post.published_at.utc.to_time.iso8601) }

  context 'with tags' do
    let(:post) { create(:post, tag_list: ['x', 'y', 'z']) }
    its(['tags']) { should eq(post.tag_list) }
  end

  context 'with a publish date' do
    let(:post) { create(:post, published_at: DateTime.now) }
    its(['publishedAt']) { should eq(post.published_at.utc.to_time.iso8601) }
  end

  context 'with a group' do
    let(:group) { post.group }
    let(:group_json) { post_json['post'] }
    it_behaves_like 'a serialized group'
  end

  context 'with an author' do
    let(:user) { post.author }
    let(:user_json) { post_json['post'] }
    let(:user_root_key) { 'author' }
    it_behaves_like 'a serialized user'
  end

  context 'with an editor' do
    let(:editor) { create(:user) }
    let(:post) { create(:post, editor: editor) }
    let(:user) { post.editor }
    let(:user_json) { post_json['post'] }
    let(:user_root_key) { 'editor' }
    it_behaves_like 'a serialized user'
  end
end
