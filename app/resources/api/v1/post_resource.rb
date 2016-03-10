class Api::V1::PostResource < JSONAPI::Resource
  before_create :set_author_as_current_user
  before_update :set_editor_as_current_user

  attributes :banner_url,
             :content,
             :group_slug,
             :kind,
             :slug,
             :tags,
             :title

  attribute :published_at, format: :iso8601
  attribute :updated_at, format: :iso8601

  has_one :author, class_name: 'User'
  has_one :editor, class_name: 'User'
  has_one :group

  filters :group, :slug, :group_id, :kind

  def group_slug
    @model.group.slug
  end

  def tags
    @model.tag_list
  end

  def tags=(tags)
    @model.tag_list = tags
  end

  private

  def self.apply_filter(records, filter, value, options)
    case filter
    when :group
      records.where(group_id: value)
    else
      return super(records, filter, value, options)
    end
  end

  def set_author_as_current_user
    @model.author = context[:current_user]
  end

  def set_editor_as_current_user
    @model.editor = context[:current_user]
  end
end
