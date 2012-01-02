class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :site_name, :default => 'My Messageboard'
      t.string :site_slug, :default => 'my-messageboard'
      t.string :email_reply_to, :default => 'My Messageboard Mail-Bot <noreply@mysite.com>'
      t.string :email_subject_prefix, :default => '[My Messageboard] '
      t.string :domain, :default => 'localhost'

      t.timestamps
    end
  end
end
