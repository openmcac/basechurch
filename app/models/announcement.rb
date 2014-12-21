class Announcement < ActiveRecord::Base
  belongs_to :post
  belongs_to :bulletin

  acts_as_list scope: :bulletin

  validates :post, presence: true
  validates :bulletin, presence: true
  validates :description, presence: true
end
