class AddAboutAndBannerUrlToGroups < ActiveRecord::Migration
  def change
    add_column :basechurch_groups, :about, :text
  end
end
