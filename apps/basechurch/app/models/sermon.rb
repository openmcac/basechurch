class Sermon < ActiveRecord::Base
  belongs_to :group

  acts_as_taggable

  validates :published_at, presence: true
  validates :group, presence: true
  validates :speaker, presence: true

  has_attachment :audio
  has_attachment :banner
end
