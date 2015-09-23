class V1::UserResource < JSONAPI::Resource
  attributes :name, :email, :api_key

  model_name 'User'

  def api_key
    model.session_api_key.access_token
  end
end
