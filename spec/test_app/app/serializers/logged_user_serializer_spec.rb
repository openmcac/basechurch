require 'rails_helper'
require 'rspec/its'

describe LoggedUserSerializer do
  let(:user) { create(:user) }
  let(:user_json) { JSON.parse(LoggedUserSerializer.new(user).to_json) }

  subject { user_json['loggedUser'] }

  it 'has a "user" root element' do
    expect(user_json).to have_key('loggedUser')
  end

  its(['id']) { should eq(user.id) }
  its(['name']) { should eq(user.name) }
  its(['email']) { should eq(user.email) }

  context 'with a session api key' do
    let(:api_key) { user.session_api_key }
    let(:api_key_json) { user_json['loggedUser'] }
    let(:expected_root_key) { 'sessionApiKey' }

    it_behaves_like 'a serialized api key'
  end
end
