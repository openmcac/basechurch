class Basechurch::V1::GroupResource < JSONAPI::Resource
  attributes :name, :slug, :created_at, :about
  attribute :created_at, format: :iso8601
  attribute :banner_url

  model_name 'Basechurch::Group'

  filter :slug

  def banner_url
    @model.banner_url
  end

  def self.apply_filter(records, filter, value, options)
    case filter
    when :slug
      records.where(slug: value)
    else
      return super(records, filter, value, options)
    end
  end
end
