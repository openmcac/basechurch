class Announcement < ActiveRecord::Base
  belongs_to :post
  belongs_to :bulletin
end
