require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  context '#before_create' do
    let(:api_key) { create(:api_key) }

    subject { api_key }

    its(:access_token) { should =~ /\S{32}/ }

    context 'where the generated access token has already been used' do
      let(:unique_access_token) { '2222' }
      before do
        keys = create_list(:api_key, 3)
        tokens = keys.map(&:access_token)
        tokens << unique_access_token
        expect(SecureRandom).to receive(:hex).and_return(*tokens)
      end

      it 'regenerates tokens until a new one is found' do
        expect(api_key.access_token).to eq(unique_access_token)
      end
    end

    context 'where the scope is session' do
      let(:api_key) { create(:api_key, scope: 'session') }

      it 'sets the proper expiry date' do
        Timecop.freeze do
          expect(api_key.expired_at).to eq(4.days.from_now)
        end
      end
    end

    context 'where the scope is api' do
      let(:api_key) { create(:api_key, scope: 'api') }

      it 'sets the proper expiry date' do
        Timecop.freeze do
          expect(api_key.expired_at).to eq(30.days.from_now)
        end
      end
    end
  end

  context 'scopes' do
    let(:session_keys) { create_list(:api_key, 3, scope: 'session') }
    let(:api_keys) { create_list(:api_key, 3, scope: 'api') }

    let!(:keys) do
      keys = session_keys + api_keys
      keys.first.update_attribute(:expired_at, 2.days.ago)
      keys
    end

    context 'active scope' do
      it 'returns all active keys' do
        expect(ApiKey.active).to eq(keys[1..keys.count])
      end
    end

    context 'api scope' do
      it 'returns all keys with api scope' do
        expect(ApiKey.api).to eq(api_keys)
      end
    end

    context 'session scope' do
      it 'returns all keys with session scope' do
        expect(ApiKey.session).to eq(session_keys)
      end
    end
  end
end
