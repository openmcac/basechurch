class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  include ActionController::StrongParameters

  respond_to :json

  def current_user
    api_key = ApiKey.active.where(access_token: token).first
    api_key.try(:user)
  end

  def token
    bearer = request.headers['HTTP_AUTHORIZATION']
    return bearer.split.last if bearer.present?
    nil
  end
end
