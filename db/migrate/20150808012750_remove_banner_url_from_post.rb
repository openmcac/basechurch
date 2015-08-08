class RemoveBannerUrlFromPost < ActiveRecord::Migration
  def change
    remove_column :basechurch_posts, :banner_url, :string
  end
end
