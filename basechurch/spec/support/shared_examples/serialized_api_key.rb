# expects api_key_json
#         api_key
#         expected_root_key
shared_examples 'a serialized api key' do
  subject { api_key_json[expected_root_key] }

  it 'has the expected root element' do
    expect(api_key_json).to have_key(expected_root_key)
  end

  its(['accessToken']) { should eq(api_key.access_token) }
  its(['userId']) { should eq(api_key.user.id) }
  its(['expiredAt']) { should eq(api_key.expired_at.utc.to_time.iso8601) }
end
