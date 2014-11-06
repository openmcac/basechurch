class V1::GroupsController < ApplicationController
  serialization_scope nil

  def index
    render json: { message: 'hello world' }
  end

  def show
    group = Group.find(params['id'])
    render json: group
  end
end
