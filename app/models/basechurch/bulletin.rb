class Basechurch::Bulletin < ActiveRecord::Base
  belongs_to :group
  has_many :announcements

  validates :group, presence: true
  validates :published_at, presence: true

  has_attachment :banner
  has_attachment :audio

  scope :english_service, -> { where(group_id: 1) }
  scope :latest, -> do
    where('published_at <= ?', DateTime.now).order('published_at DESC')
  end
end
