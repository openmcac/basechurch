class SessionsController < Devise::SessionsController
  def default_serializer_options
    { serializer: LoggedUserSerializer, root: 'user' }
  end
end
