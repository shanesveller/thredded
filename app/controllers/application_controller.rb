class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :site
  before_filter :theme_layout, :except => [:delete, :update, :create]
  before_filter :touch_last_seen
  helper_method :site, :messageboard, :topic, :tz_offset, :default_site

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to site_home
  end

  private

    def theme_layout
      if site && site.theme && ::Thredded.themes.keys.include?(site.theme.to_sym)
        prepend_view_path ::Thredded.themes[site.theme.to_sym]
      end
    end

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
      @tz_offset ||= Time.now.utc_offset / 1.hour
    end

    def touch_last_seen
      if current_user && messageboard
        current_user.mark_active_in!(messageboard)
      end
    end

end
