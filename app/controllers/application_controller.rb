class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  private

    def after_sign_in_path_for(resource_or_scope)
      root_url(:subdomain => params[:site_id])
    end

    def after_sign_out_path_for(resource_or_scope)
      root_url(:subdomain => params[:site_id])
    end
  
  
end
