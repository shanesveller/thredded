class PostsController < ApplicationController
  include TopicsHelper 
  load_and_authorize_resource :only => [:index, :show]
  layout 'application'
  before_filter :pad_post, :only => :create
  helper_method :messageboard, :topic

  def create
    # http://site0.thredded.dev:3000/messageboard_2/1252
    p = topic.posts.create(params[:post])
    redirect_to link_for_messageboard(site, messageboard)
  end

  def edit
    authorize! :update, post
  end

  def update
    post.update_attributes(params[:post])
    redirect_to link_for_posts(site, messageboard, topic)
  end

  def index
    @post  = topic.posts.build
    @posts = topic.posts
  end

  # ======================================
 
  def site
    @site ||= Site.where(:slug => params[:site_id]).includes(:messageboards).first
  end

  def messageboard
    @messageboard ||= site.messageboards.where(:name => params[:messageboard_id]).first
  end

  def topic
    @topic ||= messageboard.topics.find(params[:topic_id])
  end

  def post
    @post ||= topic.posts.find(params[:id]) 
  end

  def current_user_name 
    @current_user_name ||= current_user.nil? ? "anonymous" : current_user.name
  end

  # ======================================

  private

    def pad_post
      params[:post][:ip] = request.remote_ip
      params[:post][:user] = current_user
      params[:post][:messageboard] = messageboard
    end

end
