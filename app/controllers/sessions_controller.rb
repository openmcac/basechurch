class SessionsController < Devise::SessionsController
  def respond_with(resource, opts = {})
    render json: resource
  end
end
