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

    def do_or_render_error
      begin
        yield
      rescue => e
        render json: { error: e.to_s },
               status: :unprocessable_entity,
               serializer: nil
      end
    end
  end
end
