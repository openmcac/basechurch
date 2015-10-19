require 'rails_helper'

RSpec.describe Api::V1::UserResource, type: :resource do
  let(:user) { create(:user) }
  let(:resource) { Api::V1::UserResource.new(user) }

  before do
    allow(user).to receive(:tokens).and_return("random_api_key" => {})
  end

  subject { resource }

  its(:id) { is_expected.to eq(user.id) }
  its(:name) { is_expected.to eq(user.name) }
  its(:email) { is_expected.to eq(user.email) }
  its(:api_key) { is_expected.to eq("random_api_key") }
end
