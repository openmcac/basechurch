class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
end
