class AddCachedDomainToSite < ActiveRecord::Migration
  def change
    add_column :sites, :cached_domain, :string
  end
end
