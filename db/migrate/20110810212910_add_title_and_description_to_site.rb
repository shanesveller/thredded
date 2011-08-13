class AddTitleAndDescriptionToSite < ActiveRecord::Migration
  def change
    add_column :sites, :title, :string
    add_column :sites, :description, :text
  end
end
