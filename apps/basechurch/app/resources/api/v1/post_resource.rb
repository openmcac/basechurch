class Api::V1::PostResource < JSONAPI::Resource
  after_replace_fields :set_author_as_current_user
  after_replace_fields :set_editor_as_current_user

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
  filter :status, default: "published", apply: ->(records, value, _options) {
    return records if value.first == "all"

    records.where("published_at <= ?", DateTime.now)
  }

  def group_slug
    @model.group.slug
  end

  def tags
    @model.tag_list.sort
  end

  def tags=(tags)
    @model.tag_list = tags
  end

  private

  def set_author_as_current_user
    @model.author ||= context[:current_user]
  end

  def set_editor_as_current_user
    @model.editor = context[:current_user]
  end
end
