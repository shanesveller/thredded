class AddHashIdToTopics < ActiveRecord::Migration
  def up
    add_column :topics, :hash_id, :string
    add_index :topics, :hash_id

    Topic.all.each do |topic|
      execute <<-eosql
        UPDATE topics
        SET hash_id = '#{SecureRandom.hex(10)}'
        WHERE id = #{topic.id}
      eosql
    end

  end

  def down
    remove_index :topics, :hash_id
    remove_column :topics, :hash_id
  end
end
