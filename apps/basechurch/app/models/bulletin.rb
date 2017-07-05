class Bulletin < ActiveRecord::Base
  belongs_to :group
  belongs_to :sermon
  has_many :announcements
  has_attachment :audio # TODO remove when sermons fully migrated
  has_attachment :banner

  validates :group, presence: true
  validates :published_at, presence: true

  scope :english_service, -> { for_group(1) }
  scope :for_group, -> (group_id) { where(group_id: group_id) }
  scope :latest, -> { published.order('published_at DESC') }
  scope :oldest, -> { published.order('published_at') }
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
