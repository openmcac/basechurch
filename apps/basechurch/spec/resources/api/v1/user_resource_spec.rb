require 'rails_helper'

RSpec.describe Api::V1::UserResource, type: :resource do
  let(:user) { create(:user) }
  let(:resource) { Api::V1::UserResource.new(user, nil) }

  subject { resource }

  its(:id) { is_expected.to eq(user.id) }
  its(:name) { is_expected.to eq(user.name) }
  its(:email) { is_expected.to eq(user.email) }
end
