module TopicsHelper

  def link_for_create_topic(site, messageboard, topic)
    path = create_site_messageboard_topic_path(site.slug, messageboard.name, topic)
    path.gsub!("#{site.slug}/", '') unless %w{test}.include?( Rails.env )
  end

  def link_for_create_topic_post(site, messageboard, topic, post)
    path = create_site_messageboard_topic_post_path(site.slug, messageboard.name, topic, post)
    path.gsub!("#{site.slug}/", '') unless %w{test}.include?( Rails.env )
  end

end
