class BulletinSerializer < ActiveModel::Serializer
  attributes :id,
             :published_at,
             :name,
             :service_order,
             :description

  has_one :group
  has_many :announcements

  def published_at
    object.published_at.utc.to_time.iso8601
  end
end
