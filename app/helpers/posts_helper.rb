module PostsHelper
  def link_to_edit_post(site, messageboard, topic, post)
    path = edit_site_messageboard_topic_post_path(site.slug, messageboard.name, topic, post)
    path.gsub!("#{site.slug}/", '') unless %w{test}.include?( Rails.env )
  end
end
