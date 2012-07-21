class MessageboardsController < ApplicationController
  load_and_authorize_resource
  before_filter :messageboard, only: :show

  def index
    unless can? :read, site
      redirect_to new_user_session_url(host: site.cached_domain)
    end
  end
end
