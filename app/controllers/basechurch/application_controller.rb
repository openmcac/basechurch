module Basechurch
  class ApplicationController < JSONAPI::ResourceController
    include ActionController::MimeResponds
    include ActionController::ImplicitRender
    include ActionController::StrongParameters

    respond_to :json

    before_action :authenticate_user_from_token!

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
  end
end
