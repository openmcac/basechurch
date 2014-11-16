class RenameDateColumn < ActiveRecord::Migration
  def change
    rename_column :bulletins, :date, :published_at
  end
end
