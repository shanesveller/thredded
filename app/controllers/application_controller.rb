class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :site
  helper_method :site, :messageboard, :topic, :tz_offset, :default_site

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to site_home
  end

  private

    def get_project
      @site ||= Site.where(:cached_domain => request.host).first
    end
    

    def after_sign_in_path_for(resource_or_scope)
      site_home
    end

    def after_sign_out_path_for(resource_or_scope)
      site_home
    end

    def site_home
      "/"
    end

    def site
      @site ||= requested_host_site or default_site
    end

    def default_site
      @default_site ||= Site.find_by_default_site(true)
    end

    def requested_host_site
      Site.where(:cached_domain => request.host).includes(:messageboards).order('messageboards.id ASC').first
    end

    def messageboard
      @messageboard ||= site.messageboards.where(:name => params[:messageboard_id]).order('id ASC').first
    end

    def topic
      @topic ||= messageboard.topics.find(params[:topic_id])
    end

    def tz_offset
      Time.zone = current_user.time_zone if current_user
      @tz_offset ||= Time.zone.utc_offset / 1.hour
    end

end
