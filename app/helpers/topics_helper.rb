module TopicsHelper

  # TODO : yup. this still feels wrong. wtf am I doing here?
  def link_for_messageboard(site, messageboard)
    path = site_messageboards_path(site.slug, messageboard.name)
    unless %w{test}.include?( Rails.env )
      port = request.port == 3000 ? ":3000" : ""
      path = site_messageboards_path(messageboard.name)
      path = "http://#{site.slug}.#{request.host}#{port}#{path}"
    end
    path
  end

  def link_for_create_topic(site, messageboard, topic)
    path = create_site_messageboard_topic_path(site.slug, messageboard.name, topic)
    path.gsub!("#{site.slug}/", '') unless %w{test}.include?( Rails.env )
  end

  def link_for_create_topic_post(site, messageboard, topic, post)
    path = create_site_messageboard_topic_post_path(site.slug, messageboard.name, topic, post)
    path.gsub!("#{site.slug}/", '') unless %w{test}.include?( Rails.env )
  end

end
