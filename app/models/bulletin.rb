class Bulletin < ActiveRecord::Base
  belongs_to :group
  has_many :announcements

  validates :group, presence: true
  validates :published_at, presence: true

  has_attachment :banner
  has_attachment :audio

  scope :english_service, -> { for_group(1) }
  scope :for_group, -> (group_id) { where(group_id: group_id) }
  scope :latest, -> do
    published.order('published_at DESC')
  end
  scope :oldest, -> do
    published.order('published_at')
  end

  scope :published, -> { where('published_at <= ?', DateTime.now) }

  def self.next(bulletin)
    return nil unless bulletin.published?

    published.
      where("published_at > ?", bulletin.published_at).
      where(group_id: bulletin.group_id).
      order(:published_at).
      limit(1).
      first
  end

  def self.previous(bulletin)
    published.
      where("published_at < ?", bulletin.published_at).
      where(group_id: bulletin.group_id).
      order("published_at DESC").
      limit(1).
      first
  end

  def published?
    published_at <= DateTime.now
  end
end
