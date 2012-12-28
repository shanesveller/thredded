class AddIncomingEmailHostToSites < ActiveRecord::Migration
  def change
    add_column :sites, :incoming_email_host, :string
  end
end
