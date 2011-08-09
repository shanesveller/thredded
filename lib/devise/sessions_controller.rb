class Devise::SessionsController < ApplicationController
  helper_method :site

  def site
    @site ||= Site.find_by_slug(params[:site_id])
  end

end
