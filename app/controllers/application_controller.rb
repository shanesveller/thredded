class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :site, :messageboard, :topic

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to site_home
  end

  private

    def after_sign_in_path_for(resource_or_scope)
      site_home
    end

    def after_sign_out_path_for(resource_or_scope)
      site_home
    end

    def site_home
      # if %w{test development}.include?( Rails.env )
      if %w{test}.include?( Rails.env )
        "/#{site.slug}"
      else
        if site.domain.nil?
          root_url(:subdomain => params[:site_id])
        else
          port = (request.port.present? && request.port.to_s != "80") ? ":#{request.port}" : ""
          "http://#{site.domain}#{port}"
        end
      end
    end

    def site
      @site ||= Site.where(:slug => params[:site_id]).includes(:messageboards).first
    end

    def messageboard
      @messageboard ||= site.messageboards.where(:name => params[:messageboard_id]).first
    end

    def topic
      @topic ||= messageboard.topics.find(params[:topic_id])
    end

end
