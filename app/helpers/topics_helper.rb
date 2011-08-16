module TopicsHelper

  def link_for_user(site, user)
    if %w{test}.include?( Rails.env )
      site_user_path(site, user) 
    else
      site_user_path(user) 
    end
  end

end
