class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  validates :url, url: { allow_blank: true }
end
