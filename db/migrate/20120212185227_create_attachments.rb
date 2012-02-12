class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :attachment
      t.string :content_type
      t.integer :file_size
      t.integer :post_id

      t.timestamps
    end
  end
end
