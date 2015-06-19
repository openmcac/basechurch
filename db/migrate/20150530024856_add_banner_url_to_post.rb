class AddBannerUrlToPost < ActiveRecord::Migration
  def change
    add_column :basechurch_posts, :banner_url, :string
  end
end
