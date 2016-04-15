class AddDetailsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :short_description, :string
    add_column :groups, :target_audience, :string
    add_column :groups, :meet_details, :string
  end
end
