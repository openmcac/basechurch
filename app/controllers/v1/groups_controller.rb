class V1::GroupsController < ApplicationController
  serialization_scope nil

  def show
    group = Group.find(params['id'])
    render json: group
  end
end
