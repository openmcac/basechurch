class V1::BulletinsController < ApplicationController
  serialization_scope nil

  before_action :ensure_valid_params, only: [:create]
  before_action :set_bulletin, only: [:create]

  def show
    bulletin = Bulletin.find(params['id'])
    render json: bulletin
  end

  def create
    @bulletin.save!
    render json: @bulletin.reload
  end

  private
  def ensure_valid_params
    begin
      DateTime.iso8601(user_params[:date])
    rescue
      head :unprocessable_entity
    end
  end

  def set_bulletin
    @bulletin = Bulletin.new
    @bulletin.name = user_params[:name]
    @bulletin.date = DateTime.iso8601(user_params[:date])
    @bulletin.description = user_params[:description]
    @bulletin.service_order = user_params[:serviceOrder]
  end

  def user_params
    params.require(:bulletin)
  end
end
