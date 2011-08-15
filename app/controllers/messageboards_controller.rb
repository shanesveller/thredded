class MessageboardsController < ApplicationController
  load_and_authorize_resource
  before_filter :messageboard, :only => :show
  layout 'application'
  helper_method :site, :messageboard, :topic
  
  def index
    redirect_to default_home        and return if params[:site_id].nil?      
    redirect_to login_url_for(site) and return unless can? :read, site
    @messageboards = site.messageboards
  end

  def show
    redirect_to topics_path(@messageboard)
  end

  # ======================================
  
  def default_home
    if %w{test development}.include?( Rails.env )
      site_messageboards_path(THREDDED[:default_site]) 
    else
      root_url(:host => THREDDED[:default_domain])
    end
  end

  def login_url_for(site)
    if %w{test development}.include?( Rails.env )
      new_user_session_path(site.slug)
    else
      if site.domain.nil?
        new_user_session_url(:host => "#{site.slug}.#{THREDDED[:default_domain]}") 
      else
        new_user_session_url(:host => THREDDED[:default_domain]) 
      end 
    end
  end

  def messageboard
    @messageboard ||= Messageboard.where(:name => params[:messageboard_id]).first
  end

  def site
    @site ||= Site.where(:slug => params[:site_id]).includes(:messageboards).first
  end

end
