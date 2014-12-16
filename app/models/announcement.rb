class Announcement < ActiveRecord::Base
  belongs_to :post
  belongs_to :bulletin

  validates :post, presence: true
  validates :bulletin, presence: true
  validates :description, presence: true
end
