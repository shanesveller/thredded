module PostsHelper

  def render_content_for(post)

    filter = post.filter
    begin
      mojule = Module::const_get filter.to_s.capitalize+"Filter"
      eval "#{mojule}.render_content(post.content)"
    rescue NameError
      BbcodeFilter.render_content(post.content) # default it to BBcode
    end

  end

  def link_to_edit_post(site, messageboard, topic, post)
    path = edit_site_messageboard_topic_post_path(site.slug, messageboard.name, topic, post)
    path.gsub!("#{site.slug}/", '') unless %w{test}.include?( Rails.env )
  end

end
