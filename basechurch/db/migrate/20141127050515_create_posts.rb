class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :group, index: true
      t.references :author, index: true
      t.references :editor, index: true
      t.string :slug
      t.string :title
      t.text :content
      t.datetime :published_at

      t.timestamps
    end
  end
end
