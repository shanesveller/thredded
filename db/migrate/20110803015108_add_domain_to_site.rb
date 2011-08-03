class AddDomainToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :domain, :string
  end

  def self.down
    remove_column :sites, :domain
  end
end
