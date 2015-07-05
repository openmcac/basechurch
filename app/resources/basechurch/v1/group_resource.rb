class Basechurch::V1::GroupResource < JSONAPI::Resource
  attributes :name, :slug
  attribute :created_at, format: :iso8601

  model_name 'Basechurch::Group'

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
