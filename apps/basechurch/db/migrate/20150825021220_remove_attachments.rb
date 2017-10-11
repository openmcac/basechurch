class RemoveAttachments < ActiveRecord::Migration
  def change
    drop_table :basechurch_attachments
  end
end
