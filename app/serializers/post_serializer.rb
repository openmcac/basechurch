class PostSerializer < ActiveModel::Serializer
  attributes :content,
             :created_at,
             :group_id,
             :id,
             :published_at,
             :slug,
             :tags,
             :title,
             :updated_at

  has_one :author
  has_one :editor
  has_one :group

  def tags
    object.tag_list
  end

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
