class Group < ActiveRecord::Base
  extend FriendlyId

  has_many :posts

  validates :name, presence: true
  validates :slug, uniqueness: { case_sensitive: false },
                   format: { with: /\A([a-zA-Z0-9-])+\z/i },
                   allow_blank: true,
                   allow_nil: true
  validates :short_description, presence: true, length: { maximum: 140 }
  validates :meet_details, presence: true, length: { maximum: 50 }
  validates :target_audience, presence: true, length: { maximum: 50 }

  has_attachment :banner
  has_attachment :profile_picture

  friendly_id :name, use: :slugged

  acts_as_taggable
end
