class Basechurch::V1::PostResource < JSONAPI::Resource
  before_create :set_author_as_current_user
  before_update :set_editor_as_current_user

  attributes :content,
             :id,
             :slug,
             :title,
             :group_slug

  attribute :published_at, format: :iso8601
  attribute :updated_at, format: :iso8601
  attribute :tags, acts_as_set: true

  has_one :author, class_name: 'User'
  has_one :editor, class_name: 'User'
  has_one :group

  model_name 'Basechurch::Post'

  filter :group

  private
  def self.apply_filter(records, filter, value)
    case filter
    when :group
      records.where(group_id: value)
    else
      return super(records, filter, value)
    end
  end

  def group_slug
    model.group.slug
  end

  def tags
    model.tag_list
  end

  def tags=(tags)
    model.tag_list = tags
  end

  def set_author_as_current_user
    model.author = context[:current_user]
  end

  def set_editor_as_current_user
    model.editor = context[:current_user]
  end
end
