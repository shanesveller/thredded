class MessageboardsController < ApplicationController
  before_filter :messageboard, :only => :show
  load_and_authorize_resource
  layout 'application'
  helper_method :messageboard, :topic
  
  def index

      debugger
      @site = Site.where(:slug => params[:site_id]).first
      @messageboards = @site.messageboards

    # @messageboard_name = messageboard.present? ? messageboard.name : THREDDED[:default_messageboard_name]
  end

  def show
    redirect_to topics_path(@messageboard)
  end

  # ======================================
  
  def messageboard
    @messageboard ||= Messageboard.where(:name => params[:id]).first
  end

end
