class Basechurch::V1::BulletinsController < Basechurch::ApplicationController
  before_action :authenticate_user!, except: [:show, :sunday]

  def sunday
    params[:id] = fetch_sunday_bulletin_id.to_s
    show
  end

  def sign
    render json: S3Signer.new.sign(type: params[:type], directory: "bulletins"),
           status: :ok
  end

  private
  def fetch_sunday_bulletin_id
    Basechurch::Bulletin.english_service.
                         where('published_at <= ?', DateTime.now).
                         order('published_at DESC').
                         pluck(:id).
                         first
  end
end
