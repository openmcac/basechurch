class Basechurch::V1::BulletinsController < Basechurch::ApplicationController
  serialization_scope nil

  before_action :authenticate_user!, except: [:show]
  before_action :set_group
  before_action :set_bulletin, only: [:create]

  def show
    bulletin = Basechurch::Bulletin.find(params['id'])
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
    @bulletin = Basechurch::Bulletin.new
    @bulletin.name = user_params[:name]
    @bulletin.display_published_at = user_params[:publishedAt]
    @bulletin.description = user_params[:description]
    @bulletin.service_order = user_params[:serviceOrder]
    @bulletin.group = @group
  end

  def set_group
    @group = Basechurch::Group.find(params[:group_id])
  end

  def user_params
    params.require(:bulletin)
  end
end
