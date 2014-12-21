class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :basechurch_announcements do |t|
      t.references :post, index: true
      t.references :bulletin, index: true
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
