require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { create(:user) }

  describe '#session_api_key' do
    context 'when user does not have an access token yet' do
      it 'creates a new one' do
        expect { user.session_api_key }.to change { ApiKey.count }.by(1)
      end
    end

    context 'when user already has access token' do
      let!(:api_key) { user.session_api_key }
      it 'reuses existing token' do
        expect { api_key }.to_not change { ApiKey.count }
        expect(user.session_api_key.access_token).
            to eq(user.session_api_key.access_token)
      end
    end
  end
end
