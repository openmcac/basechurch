class AnnouncementSerializer < ActiveModel::Serializer
  attributes :id, :description, :bulletin_id, :post_id, :position
end
