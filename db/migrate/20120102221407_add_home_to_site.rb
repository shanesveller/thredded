class AddHomeToSite < ActiveRecord::Migration
  def change
    add_column :sites, :home, :string, :default => "messageboards"
  end
end
