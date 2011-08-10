module UsersHelper

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def site 
    @site ||= Site.find_by_slug(params[:site_id])
  end

end
