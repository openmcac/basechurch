class Api::V1::UserResource < JSONAPI::Resource
  attributes :name, :email, :password

  def api_key
    @model.tokens.values.first["token"]
  end

  def client_id
    @model.tokens.keys.first
  end

  def fetchable_fields
    super - [:password]
  end
end
