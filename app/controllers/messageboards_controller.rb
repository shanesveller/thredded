class MessageboardsController < ApplicationController
  load_and_authorize_resource
  before_filter :messageboard, :only => :show
  
  def index
    redirect_to new_user_session_url(:host => site.cached_domain) unless can? :read, site
  end

  # ======================================

end
