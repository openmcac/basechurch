class Group < ActiveRecord::Base
  extend FriendlyId

  validates :name, presence: true
  validates :slug, uniqueness: { case_sensitive: false },
                   format: { with: /\A([a-zA-Z0-9-])+\z/i },
                   allow_blank: true,
                   allow_nil: true

  friendly_id :name, use: :slugged

  acts_as_taggable
end
