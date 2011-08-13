class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  private

    def after_sign_in_path_for(resource_or_scope)
      site_home
    end

    def after_sign_out_path_for(resource_or_scope)
      site_home
    end

    def site_home
      @site ||= Site.find_by_slug(params[:site_id])

      if @site.domain.nil?
        root_url(:subdomain => params[:site_id])
      else
        debugger
        port = (request.port.present? && request.port.to_s != "80") ? ":#{request.port}" : ""
        "http://#{@site.domain}#{port}"
      end
    end

end
