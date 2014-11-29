class Post < ActiveRecord::Base
  belongs_to :group
  belongs_to :author, class_name: :User
  belongs_to :editor, class_name: :User

  validates :author, presence: true
  validates :content, presence: true
  validates :editor, presence: true, unless: :new_record?
  validates :group, presence: true

  validates :display_published_at, iso8601: true

  before_save :populate_published_at

  attr_accessor :display_published_at

  private
  def populate_published_at
    unless display_published_at.blank?
      self.published_at = DateTime.iso8601(display_published_at)
    end
  end
end
