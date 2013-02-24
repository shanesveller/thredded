class MessageboardsController < ApplicationController
  before_filter :messageboard, only: :show

  def index
    unless can? :read, site
      redirect_to new_user_session_url(host: site.cached_domain)
    end

    @messageboards = Messageboard.where(site_id: site.id, closed: false)
  end
end
