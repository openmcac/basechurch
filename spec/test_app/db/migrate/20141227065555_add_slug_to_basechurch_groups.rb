class AddSlugToBasechurchGroups < ActiveRecord::Migration
  def change
    add_column :basechurch_groups, :slug, :string
    add_index :basechurch_groups, :slug, unique: true
  end
end
