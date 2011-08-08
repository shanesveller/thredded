class MessageboardsController < ApplicationController
  before_filter :messageboard, :only => :show
  load_and_authorize_resource
  layout 'application'
  helper_method :site, :messageboard, :topic
  
  def index
      @messageboards = site.messageboards
  end

  def show
    redirect_to topics_path(@messageboard)
  end

  # ======================================
  
  def messageboard
    @messageboard ||= Messageboard.where(:name => params[:messageboard_id]).first
  end

  def site
      @site ||= Site.where(:slug => params[:site_id]).includes(:messageboards).first
  end

end
