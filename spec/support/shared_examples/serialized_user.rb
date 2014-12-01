# expects user_json
#         user
#         user_root_key
shared_examples 'a serialized user' do
  subject { user_json[user_root_key] }

  it 'has a "user" root element' do
    expect(user_json).to have_key(user_root_key)
  end

  its(['id']) { should eq(user.id) }
  its(['name']) { should eq(user.name) }
  its(['email']) { should eq(user.email) }
end
