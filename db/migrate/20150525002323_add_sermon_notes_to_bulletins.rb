class AddSermonNotesToBulletins < ActiveRecord::Migration
  def change
    add_column :basechurch_bulletins, :sermon_notes, :text
  end
end
