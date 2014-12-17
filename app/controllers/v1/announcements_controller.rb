class V1::AnnouncementsController < ApplicationController
  serialization_scope nil

  before_action :set_bulletin, only: [:create, :create_at]
  before_action :set_announcement, only: [:create, :create_at]
  before_action :set_position, only: [:create_at]

  def create
    begin
      @announcement.save!
      render json: @announcement.reload
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.to_s }, status: :unprocessable_entity
    end
  end

  def create_at
    begin
      @announcement.save!
      @announcement.insert_at(@position)
      render json: @announcement.reload
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.to_s }, status: :unprocessable_entity
    end
  end

  private
  def set_bulletin
    @bulletin = Bulletin.find(params[:bulletin_id])
  end

  def set_announcement
    @announcement = Announcement.new
    @announcement.description = user_params[:description]
    @announcement.bulletin = @bulletin
    @announcement.post = Post.find(user_params[:post_id])
  end

  def set_position
    @position = params[:position].to_i
  end

  def user_params
    params.require(:announcement)
  end
end
