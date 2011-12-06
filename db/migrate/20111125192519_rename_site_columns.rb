class RenameSiteColumns < ActiveRecord::Migration
  def change
    change_table :sites do |t|
      t.rename :slug,   :subdomain
      t.rename :domain, :cname_alias
    end
  end
end
