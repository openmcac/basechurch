class Basechurch::Announcement < ActiveRecord::Base
  belongs_to :post
  belongs_to :bulletin

  acts_as_list scope: :bulletin

  validates :bulletin, presence: true
  validates :description, presence: true
end
