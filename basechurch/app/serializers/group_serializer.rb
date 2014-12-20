class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at

  def created_at
    object.created_at.utc.to_time.iso8601
  end
end
