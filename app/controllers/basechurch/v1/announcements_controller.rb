class Basechurch::V1::AnnouncementsController < Basechurch::ApplicationController
  serialization_scope nil

  before_action :authenticate_user!

  before_action :set_bulletin, only: [:create, :create_at]
  before_action :set_announcement, only: [:create, :create_at]
  before_action :set_position, only: [:create_at, :move]

  def create
    do_or_render_error do
      @announcement.save!
      render json: @announcement.reload
    end
  end

  def create_at
    do_or_render_error do
      @announcement.save!
      @announcement.insert_at(@position)
      render json: @announcement.reload
    end
  end

  def move
    do_or_render_error do
      @announcement = Basechurch::Announcement.find(params[:announcement_id])
      render json: @announcement.insert_at(@position)
    end
  end

  def update
    do_or_render_error do
      @announcement = Basechurch::Announcement.find(params[:id])
      @announcement.description = user_params[:description]
      @announcement.save!
      render json: @announcement.reload
    end
  end

  def destroy
    do_or_render_error do
      Basechurch::Announcement.find(params[:id]).destroy
      head status: :no_content
    end
  end

  private
  def set_bulletin
    @bulletin = Basechurch::Bulletin.find(user_params[:bulletin_id])
  end

  def set_announcement
    @announcement = Basechurch::Announcement.new
    @announcement.description = user_params[:description]
    @announcement.bulletin = @bulletin
    @announcement.post = Basechurch::Post.find(user_params[:post_id])
  end

  def set_position
    @position = params[:position].to_i
  end

  def do_or_render_error
    begin
      yield
    rescue => e
      render json: { error: e.to_s },
             status: :unprocessable_entity,
             serializer: nil
    end
  end

  def user_params
    params.require(:announcement)
  end
end
