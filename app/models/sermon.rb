class Sermon < ActiveRecord::Base
  belongs_to :group

  validates :published_at, presence: true
  validates :group, presence: true
  validates :speaker, presence: true

  has_attachment :audio
end
