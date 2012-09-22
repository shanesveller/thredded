class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.boolean :notify_on_mention
      t.boolean :notify_on_message

      t.timestamps
    end
  end
end
