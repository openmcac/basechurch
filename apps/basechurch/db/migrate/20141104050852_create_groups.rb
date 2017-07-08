class CreateGroups < ActiveRecord::Migration
  def change
    create_table :basechurch_groups do |t|
      t.string :name
      t.string :banner

      t.timestamps
    end
  end
end
