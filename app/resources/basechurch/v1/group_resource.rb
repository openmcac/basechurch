class Basechurch::V1::GroupResource < JSONAPI::Resource
  attribute :id
  attribute :secret

  model_name 'Basechurch::Group'

  def secret
    "this is a secret"
  end
end
