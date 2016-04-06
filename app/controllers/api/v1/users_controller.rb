class Api::V1::UsersController < ApplicationResourceController
  before_action :authenticate_user!, except: [
    :index,
    :show,
    :get_related_resources,
    :get_related_resource
  ]
end
