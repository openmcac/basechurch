class V1::AnnouncementsController < ApplicationController
  serialization_scope nil

  before_action :set_bulletin, only: [:create]
  before_action :set_announcement, only: [:create]

  def create
    begin
      @announcement.save!
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

  def user_params
    params.require(:announcement)
  end
end
