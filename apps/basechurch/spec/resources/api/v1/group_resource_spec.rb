require 'rails_helper'

RSpec.describe Api::V1::GroupResource, type: :resource do
  let(:group) do
    create(:group,
           banner_url: "http://#{Forgery("internet").domain_name}/banner.jpg",
           profile_picture_url: "http://#{Forgery("internet").domain_name}/profile.jpg")
  end
  let(:records) { Group.all }

  subject { Api::V1::GroupResource.new(group, nil) }

  its(:id) { is_expected.to eq(group.id) }
  its(:name) { is_expected.to eq(group.name) }
  its(:slug) { is_expected.to eq(group.slug) }
  its(:created_at) { is_expected.to eq(group.created_at) }
  its(:about) { is_expected.to eq(group.about) }
  its(:short_description) { is_expected.to eq(group.short_description) }
  its(:target_audience) { is_expected.to eq(group.target_audience) }
  its(:meet_details) { is_expected.to eq(group.meet_details) }
  its(:banner_url) { is_expected.to eq(group.banner_url) }
  its(:profile_picture_url) { is_expected.to eq(group.profile_picture_url) }

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
