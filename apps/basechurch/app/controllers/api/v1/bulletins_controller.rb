class Api::V1::BulletinsController < ApplicationResourceController
  before_action :authenticate_user!, except: [:show, :sunday, :next, :previous]
  before_action :fetch_bulletin, only: [:next, :previous]

  def sunday
    sunday_bulletin = Bulletin.english_service.
      where("published_at <= ?", 1.day.from_now).
      order("published_at DESC").
      first

    render_bulletin sunday_bulletin
  end

  def sign
    render json: S3Signer.new.sign(type: params[:type], directory: "bulletins"),
           status: :ok
  end

  def next
    render_bulletin(Bulletin.next(@bulletin, rollover: true))
  end

  def previous
    render_bulletin(Bulletin.previous(@bulletin, rollover: true))
  end

  private

  def serialization_options
    return {} unless params.has_key?("include")
    { include: params[:include].split(",") }
  end

  def render_bulletin(bulletin)
    render json: serialize_bulletin(bulletin)
  end

  def serialize_bulletin(bulletin)
    JSONAPI::ResourceSerializer.new(Api::V1::BulletinResource, serialization_options).
      serialize_to_hash(Api::V1::BulletinResource.new(bulletin, nil))
  end

  def fetch_bulletin
    @bulletin = Bulletin.find(params[:id])
  end
end
