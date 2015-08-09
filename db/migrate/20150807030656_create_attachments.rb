class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :basechurch_attachments do |t|
      t.integer :element_id, index: true
      t.string :element_type, index: true
      t.string :element_key, index: true
      t.string :url, index: true

      t.timestamps
    end
  end
end
