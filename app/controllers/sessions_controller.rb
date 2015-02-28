class SessionsController < Devise::SessionsController
  skip_before_action :setup_request

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    yield resource if block_given?
    user =
      Basechurch::V1::UserResource.find_by_key(resource.id, context: context)

    render json: JSONAPI::ResourceSerializer.new(Basechurch::V1::UserResource).
                                             serialize_to_hash(user)
  end
end
