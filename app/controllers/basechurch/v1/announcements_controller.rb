class Basechurch::V1::AnnouncementsController < Basechurch::ApplicationController
  before_action :authenticate_user!, except: [:show]

  before_action :set_position, only: [:move]

  after_action :move_to_position, only: [:create]

  def move_to_position
  end

  def move
    @announcement = Basechurch::Announcement.find(params[:announcement_id])
    @announcement.insert_at(@position)
  end

  private
  def set_position
    @position = params[:position].to_i
  end

  def user_params
    params.require(:announcement)
  end
end
