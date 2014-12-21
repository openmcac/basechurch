class CreateUsers < ActiveRecord::Migration
  def change
    create_table :basechurch_users do |t|
      t.string :email
      t.string :name

      t.timestamps
    end
  end
end
