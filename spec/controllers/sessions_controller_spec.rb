require 'rails_helper'

describe SessionsController do
  describe '#create' do
    context 'with valid credentials' do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it 'returns the api key in the body' do
        expect(response.body).to eq('asdfasd')
      end
    end
  end
end
