class Api::V1::GroupsController < ApplicationController
  def index
    render json: { message: 'hello world' }
  end
end
