class RenameBasechurchTables < ActiveRecord::Migration
  def change
    rename_table :basechurch_announcements, :announcements
    rename_table :basechurch_api_keys, :api_keys
    rename_table :basechurch_attachments, :attachments
    rename_table :basechurch_bulletins, :bulletins
    rename_table :basechurch_groups, :groups
    rename_table :basechurch_posts, :posts
    rename_table :basechurch_users, :users
  end
end
