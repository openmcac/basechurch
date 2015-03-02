class Basechurch::V1::BulletinResource < JSONAPI::Resource
  attributes :id,
             :description,
             :name,
             :service_order
  attribute :published_at, format: :iso8601

  has_one :group
  has_many :announcements

  model_name 'Basechurch::Bulletin'
end
