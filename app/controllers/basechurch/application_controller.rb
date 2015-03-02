module Basechurch
  class ApplicationController < JSONAPI::ResourceController
    include ActionController::Serialization
    include ActionController::MimeResponds
    include ActionController::ImplicitRender
    include ActionController::StrongParameters

    respond_to :json

    before_action :authenticate_user_from_token!

    private
    def authenticate_user_from_token!
      return unless request.headers['X-User-Email']

      email = request.headers['X-User-Email']
      user = email && User.find_by_email(email)
      token = request.headers['X-User-Token']

      if user && Devise.secure_compare(user.session_api_key.access_token, token)
        sign_in user, store: false
      end
    end

    def context
      {
        current_user: current_user
      }
    end
  end
end
