class AddAboutAndBannerUrlToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :about, :text
  end
end
