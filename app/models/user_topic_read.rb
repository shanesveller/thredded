class UserTopicRead < ActiveRecord::Base
  attr_accessible :page, :post_id, :posts_count, :topic_id, :user_id

  def self.find_or_create_by_user_and_topic(user, topic)
    if user
      user_topic_read = find_by_user_id_and_topic_id(user.id, topic.id)

      if user_topic_read.blank?
        last_post = topic.posts.last
        posts_count = topic.posts.size
        page = (posts_count.to_f / 50.0).ceil
        user_topic_read = create(user_id: user.id, topic_id: topic.id,
          post_id: last_post.id, posts_count: posts_count, page: page)
      else
        user_topic_read
      end
    else
      NullTopicRead.new
    end
  end

  def update_status(current_last_post, current_posts_count)
    if current_posts_count != posts_count && current_last_post.id != post_id
      self.update_attributes(post_id: current_last_post.id,
        posts_count: current_posts_count, page: 1)
    end
  end

  def self.statuses_for(user, topics)
    if user && topics
      topic_ids = topics.map { |topic| topic.id  }
      where('user_id = ?', user.id).find_all_by_topic_id(topic_ids)
    end
  end
end
