class Api::V1::BulletinsController < ApplicationResourceController
  before_action :authenticate_user!, except: [:show, :sunday, :next, :previous]
  before_action :fetch_bulletin, only: [:next, :previous]

  def sunday
    render_bulletin Bulletin.english_service.latest.first
  end

  def sign
    render json: S3Signer.new.sign(type: params[:type], directory: "bulletins"),
           status: :ok
  end

  def next
    next_bulletin = Bulletin.next(@bulletin) ||
      Bulletin.for_group(@bulletin.group_id).published.first

    render_bulletin(next_bulletin)
  end

  def previous
    previous_bulletin = Bulletin.previous(@bulletin) ||
      Bulletin.for_group(@bulletin.group_id).latest.first

    render_bulletin(previous_bulletin)
  end

  private

  def render_bulletin(bulletin)
    render json: serialize_bulletin(bulletin)
  end

  def serialize_bulletin(bulletin)
    JSONAPI::ResourceSerializer.new(Api::V1::BulletinResource).
      serialize_to_hash(Api::V1::BulletinResource.new(bulletin, nil))
  end

  def fetch_bulletin
    @bulletin = Bulletin.find(params[:id])
  end
end
