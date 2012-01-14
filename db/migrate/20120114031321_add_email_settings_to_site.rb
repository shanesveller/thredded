class AddEmailSettingsToSite < ActiveRecord::Migration
  def change
    add_column :sites, :email_from, :string, :default => 'My Messageboard Mail-Bot <noreply@mysite.com>'
    add_column :sites, :email_subject_prefix, :string, :default => '[My Messageboard] '
    add_column :sites, :default_site, :boolean, :default => false
  end
end
