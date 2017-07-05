class RegistrationsController < DeviseTokenAuth::RegistrationsController
  def render_create_success
    serializer = JSONAPI::ResourceSerializer.new(Api::V1::UserResource)
    resource = Api::V1::UserResource.new(@resource, {})
    render json: serializer.serialize_to_hash(resource)
  end
end
