# expects group_json
#         group
shared_examples 'a serialized group' do
  subject { group_json['group'] }

  it 'has a "group" root element' do
    expect(group_json).to have_key('group')
  end

  its(['id']) { should eq(group.id) }
  its(['name']) { should eq(group.name) }
  its(['slug']) { should eq(group.slug) }
  its(['createdAt']) { should eq(group.created_at.utc.to_time.iso8601) }
end
