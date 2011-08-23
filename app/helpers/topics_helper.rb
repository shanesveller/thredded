module TopicsHelper

  def link_for_user(site, user)
    if %w{test}.include?( Rails.env )
      site_user_path(site, user) 
    else
      site_user_path(user) 
    end
  end

  def link_for_new_topic(site, messageboard)
    path = new_site_messageboard_topic_path(site.slug, messageboard)
    path.gsub!("#{site.slug}/", '') unless %w{test}.include?( Rails.env )
  end

end
