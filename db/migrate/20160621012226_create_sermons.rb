class CreateSermons < ActiveRecord::Migration
  def change
    create_table :sermons do |t|
      t.references :group, index: true, foreign_key: true
      t.timestamp :published_at, null: false
      t.text :notes
      t.string :speaker, null: false
      t.string :series

      t.timestamps null: false
    end
  end
end
