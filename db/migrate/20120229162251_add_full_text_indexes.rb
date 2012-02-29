class AddFullTextIndexes < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute <<-SQL
      CREATE INDEX topics_to_tsvector_idx ON topics USING gin( to_tsvector('english', title))
    SQL

    ActiveRecord::Base.connection.execute <<-SQL
      CREATE INDEX posts_to_tsvector_idx ON posts USING gin( to_tsvector('english', content))
    SQL
  end

  def down
  end
end
