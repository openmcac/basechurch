require 'rails_helper'
require 'rspec/its'

describe UserSerializer do
  let(:user) { create(:user) }
  let(:user_json) { JSON.parse(UserSerializer.new(user).to_json) }

  subject { user_json['user'] }

  it 'has a "user" root element' do
    expect(user_json).to have_key('user')
  end

  its(['id']) { should eq(user.id) }
  its(['name']) { should eq(user.name) }
  its(['email']) { should eq(user.email) }
end
