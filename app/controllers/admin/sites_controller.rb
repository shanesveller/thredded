class Admin::SitesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def edit
    @new_users = User.all.map{ |u| u if u.roles.empty? }.compact
  end

  def update
    site.update_attributes(params[:site])
    redirect_to edit_admin_site_path(site.id)
  end

end
