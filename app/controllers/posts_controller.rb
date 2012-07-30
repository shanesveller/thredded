class PostsController < ApplicationController
  include TopicsHelper 
  load_and_authorize_resource :only => [:index, :show]

  before_filter :pad_post, :only => :create
  helper_method :messageboard, :topic
  layout 'application'

  def create
    p = topic.posts.create(params[:post])
    redirect_to messageboard_topic_posts_url(messageboard, topic, :host => @site.cached_domain)
  end

  def edit
    authorize! :update, post
  end

  def index
    authorize! :show, topic
    @post = Post.new
    currently_read.update_status(topic.posts.last, topic.posts_count)
  end

  def post
    @post ||= topic.posts.find(params[:post_id]) 
  end

  def update
    post.update_attributes(params[:post])
    redirect_to messageboard_topic_posts_url(messageboard, topic, :host => @site.cached_domain)
  end

  private

  def currently_read
    @currently_read ||= UserTopicRead.find_or_create_by_user_and_topic(current_user, topic)
  end

  def pad_post
    params[:post][:ip] = request.remote_ip
    params[:post][:user] = current_user
    params[:post][:messageboard] = messageboard
  end
end
