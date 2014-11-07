class BulletinSerializer < ActiveModel::Serializer
  attributes :id, :date, :name, :service_order, :description

  def date
    object.date.utc.to_time.iso8601
  end
end
