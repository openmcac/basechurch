class PostSerializer < ActiveModel::Serializer
  attributes :id,
             :editor,
             :title,
             :content,
             :published_at,
             :created_at,
             :updated_at

  has_one :group
  has_one :author

  def created_at
    object.created_at.utc.to_time.iso8601
  end

  def updated_at
    object.updated_at.utc.to_time.iso8601 if object.updated_at
  end

  def published_at
    object.published_at.utc.to_time.iso8601 if object.published_at
  end
end
