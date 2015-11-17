class Api::V1::UserResource < JSONAPI::Resource
  attributes :name, :email, :api_key, :client_id

  def api_key
    model.tokens.values.first["token"]
  end

  def client_id
    model.tokens.keys.first
  end
end
