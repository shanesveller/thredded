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
      @link_or_text = link_to messageboard.name, site_messageboards_path(messageboard)
    else
      @link_or_text = messageboard.name
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
    if can? :read, messageboard and messageboard.topics.first.present?
      link_to time_ago_in_words(messageboard.topics.first.updated_at)+" ago", site_messageboard_topic_posts_path(site, messageboard, messageboard.topics.first)
    elsif messageboard.topics.first.present?
      time_ago_in_words(messageboard.topics.first.updated_at)+" ago"
    else
      ""
    end
  end

  def latest_user_for(messageboard)
    if messageboard.topics.first.present?
      messageboard.topics.first.user_name
    else
      ""
    end
  end

end
