class CreateBasechurchAttachments < ActiveRecord::Migration
  def change
    create_table :basechurch_attachments do |t|
      t.string :key
      t.string :url
      t.references :attachable, polymorphic: true, index: { name: "attachments_polymorphic_keys_index" }

      t.timestamps
    end
  end
end
