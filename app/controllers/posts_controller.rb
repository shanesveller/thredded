class PostsController < ApplicationController
  include TopicsHelper 
  load_and_authorize_resource :only => [:index, :show]
  layout 'application'
  before_filter :pad_post, :only => :create
  helper_method :messageboard, :topic

  def create
    p = topic.posts.create(params[:post])
    redirect_to messageboard_topic_url(messageboard, topic, :host => @site.cached_domain)
  end

  def edit
    authorize! :update, post
  end

  def update
    post.update_attributes(params[:post])
    redirect_to link_for_posts(site, messageboard, topic)
  end

  # ======================================
 
  def post
    @post ||= topic.posts.find(params[:post_id]) 
  end

  # ======================================

  private

    def pad_post
      params[:post][:ip] = request.remote_ip
      params[:post][:user] = current_user
      params[:post][:messageboard] = messageboard
    end

end
