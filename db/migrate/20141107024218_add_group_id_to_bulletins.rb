class AddGroupIdToBulletins < ActiveRecord::Migration
  def change
    add_column :bulletins, :group_id, :number
  end
end