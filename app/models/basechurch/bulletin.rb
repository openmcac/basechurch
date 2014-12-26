class Basechurch::Bulletin < ActiveRecord::Base
  belongs_to :group
  has_many :announcements

  before_save :populate_published_at
  validates :group, presence: true
  validates :display_published_at, iso8601: true, presence: true

  attr_accessor :display_published_at

  scope :english_service, -> { where(group_id: 1) }

  private
  def populate_published_at
    self.published_at = DateTime.iso8601(display_published_at)
  end
end
