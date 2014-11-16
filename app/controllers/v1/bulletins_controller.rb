class V1::BulletinsController < ApplicationController
  serialization_scope nil

  before_action :set_bulletin, only: [:create]

  def show
    bulletin = Bulletin.find(params['id'])
    render json: bulletin
  end

  def create
    begin
      @bulletin.save!
      render json: @bulletin.reload
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.to_s }, status: :unprocessable_entity
    end
  end

  private
  def set_bulletin
    @bulletin = Bulletin.new
    @bulletin.name = user_params[:name]
    @bulletin.display_published_at = user_params[:publishedAt]
    @bulletin.description = user_params[:description]
    @bulletin.service_order = user_params[:serviceOrder]
  end

  def user_params
    params.require(:bulletin)
  end
end
