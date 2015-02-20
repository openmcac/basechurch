require 'rails_helper'

RSpec.describe Basechurch::V1::GroupResource, :type => :resource do
  let(:group) { create(:group) }

  subject { Basechurch::V1::GroupResource.new(group) }

  its(:id) { is_expected.to eq(group.id) }
  its(:name) { is_expected.to eq(group.name) }
  its(:slug) { is_expected.to eq(group.slug) }
  its(:created_at) { is_expected.to eq(group.created_at) }
end
