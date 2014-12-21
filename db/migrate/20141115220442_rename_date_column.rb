class RenameDateColumn < ActiveRecord::Migration
  def change
    rename_column :basechurch_bulletins, :date, :published_at
  end
end
