class GroupSerializer < ActiveModel::Serializer
  attributes :name, :created_at

  def created_at
    object.created_at.utc.to_time.iso8601
  end
end
