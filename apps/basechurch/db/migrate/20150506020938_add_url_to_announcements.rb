class AddUrlToAnnouncements < ActiveRecord::Migration
  def change
    add_column :basechurch_announcements, :url, :string
  end
end
