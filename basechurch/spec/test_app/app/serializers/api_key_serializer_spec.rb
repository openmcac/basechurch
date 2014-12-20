require 'rails_helper'
require 'rspec/its'

describe ApiKeySerializer do
  let(:api_key) { create(:api_key) }
  let(:api_key_json) { JSON.parse(ApiKeySerializer.new(api_key).to_json) }
  let(:expected_root_key) { 'apiKey' }

  it_behaves_like 'a serialized api key'
end
