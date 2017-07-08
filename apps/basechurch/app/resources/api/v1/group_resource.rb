class Api::V1::GroupResource < JSONAPI::Resource
  attributes :about,
             :banner_url,
             :meet_details,
             :name,
             :profile_picture_url,
             :short_description,
             :slug,
             :target_audience

  attribute :created_at, format: :iso8601

  has_many :posts

  filter :slug

  def self.apply_filter(records, filter, value, options)
    case filter
    when :slug
      records.where(slug: value)
    else
      return super(records, filter, value, options)
    end
  end
end
