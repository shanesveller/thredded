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
      @link_or_text = link_to messageboard.title, messageboard_topics_path(messageboard)
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

    if topic.present?
      abbr = content_tag :abbr, :class => "updated_at timeago", :title => topic.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ") do
        topic.updated_at.strftime("%b %d, %Y %I:%M:%S %Z")
      end
      if can? :read, messageboard
        link_to abbr , messageboard_topic_posts_path(messageboard, topic)
      else
        abbr
      end
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
