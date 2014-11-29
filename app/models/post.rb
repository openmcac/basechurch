class Post < ActiveRecord::Base
  belongs_to :group
  belongs_to :author, class_name: :User
  belongs_to :editor, class_name: :User

  validates :author, presence: true
  validates :content, presence: true
  validates :editor, presence: true, unless: :new_record?
  validates :group, presence: true
end
