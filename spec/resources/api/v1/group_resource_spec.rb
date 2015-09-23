require 'rails_helper'

RSpec.describe Api::V1::GroupResource, type: :resource do
  let(:group) { create(:group) }
  let(:records) { Group.all }

  subject { Api::V1::GroupResource.new(group) }

  its(:id) { is_expected.to eq(group.id) }
  its(:name) { is_expected.to eq(group.name) }
  its(:slug) { is_expected.to eq(group.slug) }
  its(:created_at) { is_expected.to eq(group.created_at) }

  describe 'apply_filter' do
    let(:options) { {} }

    subject do
      Api::V1::GroupResource.apply_filter(records, filter, value, options)
    end

    context 'when filter is something else' do
      let(:filter) { 'name' }
      let(:value) { 'whatever' }

      before { group }

      it { is_expected.to eq([]) }
    end

    context 'when filter is :slug' do
      let(:filter) { :slug }
      let(:value) { group.slug }

      before do
        create(:group)
        group
        create(:group)
      end

      it { is_expected.to eq([group]) }
    end
  end
end
