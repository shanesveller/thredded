module MessageboardHelper

  def privacy_class(messageboard)
    if can? :read, messageboard 
      "" 
    else
      "private"
    end
  end


  def link_or_text_to(messageboard)
    @link_or_text = ""
    if can? :read, messageboard 
      @link_or_text = link_to messageboard.title, messageboard_path(messageboard)
    else
      @link_or_text = messageboard.title
    end
    @link_or_text
  end

  def meta_for(messageboard)
    "#{messageboard.topics_count} topic(s), #{messageboard.posts_count} post(s)"
  end

  def admin_link_for(messageboard)
    if can? :manage, messageboard
      "<p class=\"admin\"><a href=\"#edit\">Edit</a></p>"
    else
      ""
    end
  end

  def latest_thread_for(messageboard)
    topic = messageboard.topics.first
    if can? :read, messageboard and topic.present?
      link_to time_ago_in_words(topic.updated_at)+" ago", messageboard_topic_path(messageboard, topic)
    elsif topic.present?
      time_ago_in_words(topic.updated_at)+" ago"
    else
      ""
    end
  end

  def latest_user_for(messageboard)
    if messageboard.topics.first.present? && messageboard.topics.first.user.present?
      messageboard.topics.first.user_name
    else
      ""
    end
  end

end
