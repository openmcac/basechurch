class Bulletin < ActiveRecord::Base
  belongs_to :group
  before_save :populate_published_at
  validate :display_published_at_must_be_correct_format
  validates :group, presence: true

  attr_accessor :display_published_at

  private
  def populate_published_at
    self.published_at = DateTime.iso8601(display_published_at)
  end

  def display_published_at_must_be_correct_format
    begin
      DateTime.iso8601(display_published_at)
    rescue ArgumentError
      errors.add(:date, 'must be in ISO8601 format')
    end
  end
end
