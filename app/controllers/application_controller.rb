class ApplicationController < JSONAPI::ResourceController
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  include ActionController::StrongParameters

  respond_to :json

  before_action :authenticate_user_from_token!
  before_action :set_cors_headers, if: "Rails.env.development?"

  private
  def authenticate_user_from_token!
    sign_in user_from_token, store: false if user_from_token
  end

  def context
    {
      current_user: current_user || user_from_token
    }
  end

  def fetch_user_from_token
    return unless request.headers['X-User-Email']

    email = request.headers['X-User-Email']
    user = email && User.find_by_email(email)
    token = request.headers['X-User-Token']

    return unless user && Devise.secure_compare(user.session_api_key.access_token,
                                                token)

    user
  end

  def user_from_token
    @user_from_token ||= fetch_user_from_token
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
