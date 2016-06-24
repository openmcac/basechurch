class Api::V1::SermonResource < JSONAPI::Resource
  attributes :name, :notes, :speaker, :series, :banner_url, :audio_url
  attribute :published_at, format: :iso8601

  has_one :bulletin
  has_one :group
end
