class AddSermonIdToBulletins < ActiveRecord::Migration
  def change
    add_reference :bulletins, :sermon, index: true, foreign_key: true
  end
end
