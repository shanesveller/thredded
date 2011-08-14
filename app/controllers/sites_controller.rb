class SitesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
    @site = params[:site_id].present? ? Site.find(params[:site_id]) : Site.first
    @messageboards = @site.messageboards
  end

end
