class Basechurch::Post < ActiveRecord::Base
  extend FriendlyId

  friendly_id :generate_slug, use: :slugged

  belongs_to :group
  belongs_to :author, class_name: :User
  belongs_to :editor, class_name: :User

  validates :author, presence: true
  validates :content, presence: true
  validates :editor, presence: true, unless: :new_record?
  validates :group, presence: true
  validates :display_published_at, iso8601: true

  acts_as_taggable

  before_save :populate_published_at

  attr_accessor :display_published_at

  private
  def populate_published_at
    self.published_at = published_at_or_now
  end

  def published_at_or_now
    if display_published_at.blank?
      DateTime.now
    else
      DateTime.iso8601(display_published_at)
    end
  end

  def generate_slug
    shorten(title.nil? ? content : title)
  end

  def shorten(str)
    max_words = 10
    str.split[0..(max_words - 1)].join(' ')
  end
end
