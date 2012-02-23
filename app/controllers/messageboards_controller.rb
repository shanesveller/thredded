class MessageboardsController < ApplicationController
  load_and_authorize_resource
  before_filter :messageboard, :only => :show
  
  def index
    redirect_to new_user_session_url(:host => site.cached_domain) unless can? :read, site
  end

  def show
    unless site.present? and can? :read, messageboard
      redirect_to default_home, :flash => { :error => "You are not authorized access to this messageboard." } and return 
    end

    if params[:q].present?
      @results = TopicPostSearch.new( params[:q], messageboard.name ) 
      redirect_to messageboard_path(messageboard), :flash => { :error => "No topics found for this search." } unless @results.length > 0
      @topics = []
      @results.each {|f| @topics.push f.topic}
    else
      @topics = messageboard.topics
    end

    @messageboards = site.messageboards
  end

  # ======================================

private

  def default_home
    root_url(:host => site.cached_domain)
  end

end
