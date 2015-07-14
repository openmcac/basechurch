class AddAboutAndBannerUrlToGroups < ActiveRecord::Migration
  def change
    add_column :basechurch_groups, :about, :text
    add_column :basechurch_groups, :banner_url, :string
  end
end
