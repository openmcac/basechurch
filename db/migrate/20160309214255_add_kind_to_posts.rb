class AddKindToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :kind, :integer, default: 0
  end
end
