class Api::V1::UserResource < JSONAPI::Resource
  attributes :name, :email, :api_key

  def api_key
    model.tokens.keys.first
  end
end
