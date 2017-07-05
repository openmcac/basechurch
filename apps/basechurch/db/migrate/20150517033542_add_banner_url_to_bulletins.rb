class AddBannerUrlToBulletins < ActiveRecord::Migration
  def change
    add_column :basechurch_bulletins, :banner_url, :string
  end
end
