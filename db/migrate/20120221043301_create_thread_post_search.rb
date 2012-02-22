class CreateTopicPostSearch < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute <<-SQL
    CREATE VIEW topic_post_searches AS
    SELECT p.topic_id as topic_id, p.content as content, m.name as messageboard_id, 'post' as content_type
      FROM posts p, topics t, messageboards m
     WHERE p.topic_id = t.id
       AND t.messageboard_id = m.id
    UNION
    SELECT t.id as topic_id, t.title as content, m.name as messageboard_id, 'topic' as content_type
      FROM topics t, messageboards m
     WHERE t.messageboard_id = m.id
    SQL
  end

  def self.down
    ActiveRecord::Base.connection.execute <<-SQL
      DROP VIEW topic_post_searches
    SQL
  end
end
