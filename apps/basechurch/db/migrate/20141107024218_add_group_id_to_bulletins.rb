class AddGroupIdToBulletins < ActiveRecord::Migration
  def change
    add_column :basechurch_bulletins, :group_id, :integer
  end
end
