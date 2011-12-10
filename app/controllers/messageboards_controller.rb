class MessageboardsController < ApplicationController
  load_and_authorize_resource
  before_filter :messageboard, :only => :show
  layout 'application'
  
  def index
    redirect_to new_user_session_url(:host => site.cached_domain) unless can? :read, site
  end

  def show
    redirect_to default_home, :flash => { :error => "You are not authorized access to this messageboard." } and return unless site.present? and can? :read, messageboard
    @topics = messageboard.topics
    @messageboards = site.messageboards
  end

  # ======================================

private

  def default_home
    root_url(:host => site.cached_domain)
  end

end
