class CreateBulletins < ActiveRecord::Migration
  def change
    create_table :bulletins do |t|
      t.datetime :date
      t.string :name
      t.string :description
      t.text :service_order

      t.timestamps
    end
  end
end
