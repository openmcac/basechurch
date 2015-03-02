class Basechurch::V1::GroupResource < JSONAPI::Resource
  attributes :id, :name, :slug
  attribute :created_at, format: :iso8601

  model_name 'Basechurch::Group'
end
