class DropApikeysTable < ActiveRecord::Migration
  def up
    drop_table :api_keys
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
