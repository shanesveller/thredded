module ApplicationHelper
  
  def site_messageboard_path(site, messageboard)
    return "/#{site.to_param}/#{messageboard.to_param}" if needs_full_path
    "/#{messageboard.to_param}"
  end

  def new_site_messageboard_topic_path(site, messageboard)
    return "/#{site.to_param}/#{messageboard.to_param}/topics/new" if needs_full_path
    "/#{messageboard.to_param}/topics/new"
  end

  def create_site_messageboard_topic_path(site, messageboard, topic)
    return "/#{site.to_param}/#{messageboard.to_param}/topics" if needs_full_path
    "/#{messageboard.to_param}/topics"
  end

  def site_messageboard_topic_path(site, messageboard, topic)
    return "/#{site.to_param}/#{messageboard.to_param}/#{topic.to_param}" if needs_full_path
    "/#{messageboard.to_param}/#{topic.to_param}"
  end

  def site_user_path(site, user)
    return "/#{site.to_param}/users/#{user.to_param}" if needs_full_path
    "/users/#{user.to_param}"
  end

  # ========================

  def needs_full_path
    "test" == Rails.env
  end

end
