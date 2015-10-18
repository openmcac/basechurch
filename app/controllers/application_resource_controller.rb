class ApplicationResourceController < JSONAPI::ResourceController
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  include ActionController::StrongParameters
  include DeviseTokenAuth::Concerns::SetUserByToken

  respond_to :json

  before_action :set_cors_headers, if: "Rails.env.development?"

  private

  def context
    {
      current_user: current_user
    }
  end

  def resource_serializer_klass
    @resource_serializer_klass ||= BasechurchResourceSerializer
  end

  def set_cors_headers
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Headers"] =
      "X-AUTH-TOKEN, X-API-VERSION, X-Requested-With, Content-Type, Accept, Origin"
    headers["Access-Control-Allow-Methods"] =
      "POST, GET, PUT, DELETE, OPTIONS"
    headers["Access-Control-Max-Age"] = "1728000"
  end
end
