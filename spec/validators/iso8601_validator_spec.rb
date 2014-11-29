require 'rails_helper'

RSpec.describe Iso8601Validator, :type => :validator do
  let(:attribute) { :anything }
  let(:validator) { Iso8601Validator.new(attributes: [attribute]) }
  let(:record) { create(:post) }

  describe '#validate_each' do
    before { validator.validate_each(record, attribute, value) }

    context 'when value is in valid iso8601 format' do
      let(:value) { DateTime.now.utc.to_time.iso8601 }
      subject { record.errors[attribute] }
      it { should be_empty }
    end

    context 'when value is in invalid iso8601 format' do
      let(:value) { 'asdfasdf' }
      subject { record.errors[attribute] }
      it { should_not be_empty }
    end
  end
end
