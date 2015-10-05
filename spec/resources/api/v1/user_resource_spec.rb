require 'rails_helper'

RSpec.describe Api::V1::UserResource, type: :resource do
  let(:user) { create(:user) }
  let(:resource) { Api::V1::UserResource.new(user) }

  subject { resource }

  its(:id) { is_expected.to eq(user.id) }
  its(:name) { is_expected.to eq(user.name) }
  its(:email) { is_expected.to eq(user.email) }
  its(:api_key) { is_expected.to eq(user.session_api_key.access_token) }
end
