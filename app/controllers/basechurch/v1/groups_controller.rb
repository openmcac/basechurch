class Basechurch::V1::GroupsController < Basechurch::ApplicationController
  serialization_scope nil

  def show
    group = Basechurch::Group.find(params['id'])
    render json: group
  end
end
