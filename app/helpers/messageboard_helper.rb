module MessageboardHelper
  def messageboard_count
    number_to_human(app_config.messageboards_count).downcase
  end

  def topics_count
    number_to_human(app_config.topics_count, precision: 4).downcase
  end

  def posts_count
    number_to_human(app_config.posts_count, precision: 5).downcase
  end

  def latest_thread_for(messageboard)
    topic = messageboard.topics.first

    if topic.present?
      abbr = content_tag :abbr, class: 'updated_at timeago', title: topic.updated_at.strftime('%Y-%m-%dT%H:%M:%S') do
        topic.updated_at.strftime('%b %d, %Y %I:%M:%S %Z')
      end

      if can? :read, messageboard
        link_to abbr , messageboard_topic_posts_path(messageboard, topic)
      else
        abbr
      end
    else
      ''
    end
  end
end
