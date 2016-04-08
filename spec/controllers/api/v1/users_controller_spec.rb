require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }

  let(:all_attributes) do
    {
      data: {
        type: "users",
        attributes: {
          email: Forgery(:internet).email_address,
          name: Forgery(:name).full_name
        }
      }
    }
  end

  let(:valid_attributes) do
    {
      data: {
        type: "users",
        attributes: {
        }
      }
    }
  end

  shared_examples_for "a user payload" do
    it 'returns a single user' do
      data = JSON.parse(response.body)["data"]
      attributes = data["attributes"]
      expect(data["id"]).to eq user.id.to_s
      expect(data["type"]).to eq "users"
      expect(attributes["name"]).to eq user.name
      expect(attributes["email"]).to eq user.email
      expect(attributes.has_key?("password")).to eq false
    end
  end

  shared_examples_for 'a response containing a user' do
    let(:data) { JSON.parse(response.body)["data"] }
    let(:attributes) { data["attributes"] }

    it 'returns a user' do
      expect(data["id"]).to eq expected_user.id.to_s

      expect(attributes["email"]).to eq expected_user.email
      expect(attributes["name"]).to eq expected_user.name
    end
  end

  shared_examples_for 'an action to update a user' do
    let(:expected_user) { user_to_update.reload }
    let(:perform_action) { patch :update, user_params }

    context 'with an authenticated user' do
      before do
        auth_headers =
          user.create_new_auth_token.
               merge("Content-Type" => "application/vnd.api+json")
        @request.headers.merge!(auth_headers)
      end

      context 'with an updated user' do
        subject { user_to_update.reload }
        before { perform_action }

        its(:email) { is_expected.to eq user_params[:data][:attributes][:email] }
        its(:name) { is_expected.to eq user_params[:data][:attributes][:name] }

        it_behaves_like 'a response containing a user'
      end
    end

    it_behaves_like 'an authenticated action'
  end

  describe 'GET /users/:id' do
    before { get :show, id: user.id }

    it_behaves_like "a user payload"
  end

  describe 'PUT /users/:id' do
    context 'with an authenticated user' do
      let(:user_to_update) { create(:user) }

      context 'with all params provided' do
        let(:user_params) do
          all_attributes[:data][:id] = user_to_update.id
          all_attributes[:id] = user_to_update.id
          all_attributes
        end

        it_behaves_like 'an action to update a user'
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) do
          valid_attributes[:data][:id] = user_to_update.id
          valid_attributes[:id] = user_to_update.id
          valid_attributes[:data][:attributes][:email] = "notanemailaddress"
          valid_attributes
        end

        let(:perform_action) { put :update, invalid_attributes }

        before do
          auth_headers =
            user.create_new_auth_token.
                 merge("Content-Type" => "application/vnd.api+json")
          @request.headers.merge!(auth_headers)

          perform_action
        end

        it 'returns a 422 response code' do
          expect(response.status).to eq(422)
        end
      end
    end
  end
end
