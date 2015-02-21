class Basechurch::V1::AnnouncementResource < JSONAPI::Resource
  attributes :id, :description, :position

  has_one :bulletin
  has_one :post

  model_name 'Basechurch::Announcement'
end

