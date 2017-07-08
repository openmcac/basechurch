require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Users" do
  let(:response) { JSON.parse(response_body) }

  def expect_user(payload, model)
    attributes = payload["attributes"]
    expect(payload["id"]).to eq model.id.to_s
    expect(payload["type"]).to eq "users"
    expect(attributes["email"]).to eq model.email
    expect(attributes["name"]).to eq model.name
  end

  get "api/v1/users" do
    let!(:users) { create_list(:user, 3) }

    example_authenticated_request "Listing users" do
      expect(status).to eq 200
      expect_user(response["data"][0], users[0])
      expect_user(response["data"][1], users[1])
      expect_user(response["data"][2], users[2])
    end
  end

  get "api/v1/users/:id" do
    let(:user) { create(:user) }
    let(:id) { user.id }

    parameter :id, "The user id"

    example_request "Show a user" do
      expect(status).to eq 200
      expect_user(response["data"], user)
    end
  end

  put "api/v1/users/:id" do
    let(:user) { create(:user) }
    let(:id) { user.id }

    parameter :id, "The id of user to update", scope: [:data]
    parameter :name, "The updated name of user", scope: [:data, :attributes]
    parameter :type, "The type of resource to update", scope: [:data]

    let(:data_id) { user.id.to_s }
    let(:data_type) { "users" }
    let(:data_attributes_name) { "Updated Name" }

    example_authenticated_request "Update a user" do
      expect(status).to eq 200
      expect(User.find(id).name).to eq data_attributes_name
    end

    example_authenticated_request "Update a user (invalid parameters)", "data" => { "attributes" => { "email" => "notanemail" } } do
      expect(status).to eq 422
      expect(User.find(id).email).to eq user.email
    end
  end
end
