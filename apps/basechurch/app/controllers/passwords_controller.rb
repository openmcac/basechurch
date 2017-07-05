class PasswordsController < DeviseTokenAuth::PasswordsController
  def render_update_success
    serializer = JSONAPI::ResourceSerializer.new(Api::V1::UserResource)
    resource = Api::V1::UserResource.new(@resource, {})
    render json: serializer.serialize_to_hash(resource)
  end
end
