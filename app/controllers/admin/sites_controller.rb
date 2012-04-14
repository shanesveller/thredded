class Admin::SitesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def edit
    authorize! :update, site
    @site = Site.find_by_subdomain(params[:id])
    @new_users = User.all.map{ |u| u if u.roles.empty? }.compact
  end

  def update
    site.update_attributes(params[:site])
    if site.cname_alias.empty?
      redirect_to edit_admin_site_url(@site)
    else
      redirect_to edit_admin_site_url(@site, :host => site.cname_alias)
    end
  end

end
