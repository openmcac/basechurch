# expects announcement
#         announcement_json
shared_examples 'a serialized announcement' do
  subject { announcement_json['announcement'] }

  it 'has a "announcement" root element' do
    expect(announcement_json).to have_key('announcement')
  end

  its(['id']) { should eq(announcement.id) }
  its(['description']) { should eq(announcement.description) }
  its(['bulletinId']) { should eq(announcement.bulletin.id) }
  its(['postId']) { should eq(announcement.post.id) }
end
