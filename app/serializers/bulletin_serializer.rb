class BulletinSerializer < ActiveModel::Serializer
  attributes :id,
             :published_at,
             :name,
             :service_order,
             :description,
             :group

  def published_at
    object.published_at.utc.to_time.iso8601
  end
end
