class MessageboardsController < ApplicationController
  load_and_authorize_resource
  before_filter :messageboard, :only => :show
  layout 'application'
  
  def show
    redirect_to default_home        and return if params[:site_id].nil?      
    redirect_to login_url_for(site) and return unless can? :read, site
    @topics = messageboard.topics
    @messageboards = site.messageboards
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

  def login_url_for(site)
    # if %w{test development}.include?( Rails.env )
    if %w{test}.include?( Rails.env )
      new_user_session_path(site.slug)
    else
      if site.domain.nil?
        new_user_session_url(:host => "#{site.slug}.#{THREDDED[:default_domain]}") 
      else
        new_user_session_url(:host => THREDDED[:default_domain]) 
      end 
    end
  end

end
