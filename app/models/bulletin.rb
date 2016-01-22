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

  def self.next(bulletin, rollover: false)
    next_bulletin = if bulletin.published?
      published.
        where("published_at > ?", bulletin.published_at).
        for_group(bulletin.group_id).
        oldest.
        first
    end

    return next_bulletin if next_bulletin
    return unless rollover

    Bulletin.for_group(bulletin.group_id).oldest.first
  end

  def self.previous(bulletin, rollover: false)
    previous_bulletin = if bulletin.published?
      published.
        where("published_at < ?", bulletin.published_at).
        for_group(bulletin.group_id).
        latest.
        first
    end

    return previous_bulletin if previous_bulletin
    return unless rollover

    Bulletin.for_group(bulletin.group_id).latest.first
  end

  def published?
    published_at <= DateTime.now
  end
end
