class Admin::SitesController < ApplicationController
  load_and_authorize_resource

  def edit
    @site = Site.find(params[:id])
  end

  def update
    site.update_attributes(params[:site])
    redirect_to edit_admin_site_path(site.id)
  end

end
