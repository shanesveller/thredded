class MessageboardsController < ApplicationController
  load_and_authorize_resource
  before_filter :messageboard, :only => :show
  layout 'application'
  
  def show
    redirect_to default_home and return unless site.present?

    unless can? :read, messageboard
#      flash[:error] = "You are not authorized access to this messageboard. Please log in and/or gain the appropriate permissions."
#      redirect_to new_user_session_url(site) unless current_user
#      redirect_to 'http://thredded.dev:3000/' if current_user
#      return
    end

    @topics = messageboard.topics
    @messageboards = site.messageboards
  end

  # ======================================
  
  def new_user_session_url(site)
   h = Object.new.extend(ApplicationHelper)
   return new_user_session_path(site.slug) if h.needs_full_path

   port     = (request.port.present? && request.port.to_s != "80") ? ":#{request.port}" : ""
   protocol = request.ssl?                                         ? "https" : "http"
   host     = case
                when site.domain.present?; site.domain
                when site.slug.present?; "#{site.slug}.#{THREDDED[:default_domain]}"
                else THREDDED[:default_domain]
              end
   format   = params[:format].present?                             ? ".#{params[:format]}" : ""
   "#{protocol}://#{host}#{port}/users/sign_in" 
  end
  
  # ======================================

  def default_home
    # if %w{test development}.include?( Rails.env )
    if %w{test}.include?( Rails.env )
      site_messageboards_path(THREDDED[:default_site]) 
    else
      root_url(:host => THREDDED[:default_domain])
    end
  end

end
