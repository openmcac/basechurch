class Basechurch::V1::BulletinsController < Basechurch::ApplicationController
  serialization_scope nil

  before_action :authenticate_user!, except: [:show, :sunday]
  before_action :set_group, only: [:create]
  before_action :set_bulletin, only: [:create]

  def show
    bulletin = Basechurch::Bulletin.find(params['id'])
    render json: bulletin
  end

  def create
    do_or_render_error do
      @bulletin.save!
      render json: @bulletin.reload
    end
  end

  def sunday
    do_or_render_error do
      render json: fetch_sunday_bulletin
    end
  end

  private
  def fetch_sunday_bulletin
    Basechurch::Bulletin.english_service
                        .where('published_at <= ?', DateTime.now)
                        .order('published_at DESC')
                        .first
  end

  def set_bulletin
    @bulletin = Basechurch::Bulletin.new
    @bulletin.name = user_params[:name]
    @bulletin.display_published_at = user_params[:publishedAt]
    @bulletin.description = user_params[:description]
    @bulletin.service_order = user_params[:serviceOrder]
    @bulletin.group = @group
  end

  def set_group
    @group = Basechurch::Group.find(user_params[:group_id])
  end

  def user_params
    params.require(:bulletin)
  end
end
