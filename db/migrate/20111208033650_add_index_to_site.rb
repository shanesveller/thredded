class AddIndexToSite < ActiveRecord::Migration
  def change
    add_index "sites", ["cached_domain"]
  end
end
