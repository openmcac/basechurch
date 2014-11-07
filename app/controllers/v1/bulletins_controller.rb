class V1::BulletinsController < ApplicationController
  serialization_scope nil

  def show
    bulletin = Bulletin.find(params['id'])
    render json: bulletin
  end
end

