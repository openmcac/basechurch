class ApplicationResourceController < JSONAPI::ResourceController
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  include ActionController::StrongParameters
  include DeviseTokenAuth::Concerns::SetUserByToken

  private

  def context
    {
      current_user: current_user
    }
  end

  def resource_serializer_klass
    @resource_serializer_klass ||= BasechurchResourceSerializer
  end
end
