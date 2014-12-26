class BulletinSerializer < ActiveModel::Serializer
  attributes :id,
             :description,
             :group_id,
             :name,
             :published_at,
             :service_order

  has_many :announcements
  has_one :group

  def published_at
    object.published_at.utc.to_time.iso8601
  end
end
