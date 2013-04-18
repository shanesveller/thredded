class RenameSites < ActiveRecord::Migration
  def up
    rename_table :sites, :app_configs
    remove_column :app_configs, :user_id
    remove_column :app_configs, :subdomain
    remove_column :app_configs, :cname_alias
    remove_column :app_configs, :cached_domain
    remove_column :app_configs, :home
    remove_column :app_configs, :default_site
    remove_column :app_configs, :theme
  end

  def down
    rename_table :app_configs, :sites
    add_column :sites, :user_id, :integer
    add_column :sites, :subdomain, :string, default: 'thredded'
    add_column :sites, :cname_alias, :string
    add_column :sites, :cached_domain, :string
    add_column :sites, :home, :string, default: 'messageboards'
    add_column :sites, :default_site, :boolean, default: true
    add_column :sites, :theme, :string
    add_index :sites, :cached_domain
  end
end
