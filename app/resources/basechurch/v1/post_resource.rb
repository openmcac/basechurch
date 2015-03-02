class Basechurch::V1::PostResource < JSONAPI::Resource
  before_create :set_author_as_current_user
  before_update :set_editor_as_current_user

  attributes :content,
             :id,
             :slug,
             :title;

  attribute :published_at, format: :iso8601
  attribute :updated_at, format: :iso8601
  attribute :tags, acts_as_set: true

  has_one :author, class_name: 'User'
  has_one :editor, class_name: 'User'
  has_one :group

  model_name 'Basechurch::Post'

  private
  def tags
    model.tag_list
  end

  def tags=(tags)
    model.tag_list = tags
  end

  def set_author_as_current_user
    model.author = context.current_user
  end

  def set_editor_as_current_user
    model.editor = context.current_user
  end
end
