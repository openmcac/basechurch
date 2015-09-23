class V1::BulletinsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :sunday]
  prepend_before_action :imitate_show_action, only: :sunday

  def sunday
    show
  end

  def sign
    render json: S3Signer.new.sign(type: params[:type], directory: "bulletins"),
           status: :ok
  end

  private

  def imitate_show_action
    params[:id] = fetch_sunday_bulletin_id.to_s
    params[:action] = "show"
  end

  def fetch_sunday_bulletin_id
    Bulletin.english_service.
             where('published_at <= ?', DateTime.now).
             order('published_at DESC').
             pluck(:id).
             first
  end
end
