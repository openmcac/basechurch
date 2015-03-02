require 'rails_helper'

RSpec.describe Basechurch::V1::BulletinResource, :type => :resource do
  let(:bulletin) { create(:bulletin) }
  let(:resource) { Basechurch::V1::BulletinResource.new(bulletin) }
  let(:group_resource) { Basechurch::V1::GroupResource.new(bulletin.group) }

  subject { resource }

  its(:id) { is_expected.to eq(bulletin.id) }
  its(:description) { is_expected.to eq(bulletin.description) }
  its(:name) { is_expected.to eq(bulletin.name) }
  its(:published_at) { is_expected.to eq(bulletin.published_at) }
  its(:service_order) { is_expected.to eq(bulletin.service_order) }

  describe "#group" do
    subject { resource.group.id }
    it { is_expected.to eq(group_resource.id) }
  end
end

