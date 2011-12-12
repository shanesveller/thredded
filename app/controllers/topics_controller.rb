class TopicsController < ApplicationController
  before_filter :pad_params,  :only => [:create, :update]
  before_filter :pad_post,    :only => :create
  before_filter :pad_topic,   :only => :create

  def show
    authorize! :show, topic
    @post = Post.new
  end

  def new
    @topic = messageboard.topics.build
    @topic.type = "PrivateTopic" if params[:type] == "private"
    @topic.posts.build
  end

  def create
    @topic = klass.create(params[:topic])
    redirect_to messageboard_url(messageboard, :host => @site.cached_domain)
  end

  def edit
    authorize! :update, topic
  end
 
  def update
    topic.update_attributes(params[:topic])
    redirect_to messageboard_topic_path(messageboard, topic)
  end

  # ======================================

  def current_user_name 
    @current_user_name ||= current_user.nil? ? "anonymous" : current_user.name
  end

  # ======================================

  private

    def klass
      @klass ||= params[:topic][:type].present? ? params[:topic][:type].constantize : Topic
    end

    def pad_params
      params[:topic][:user] = current_user
      params[:topic][:last_user] = current_user
    end

    def pad_topic
      params[:topic][:user_id] << current_user.id.to_s if current_user and params[:topic][:user_id].present?
      params[:topic][:last_user] = current_user
      params[:topic][:messageboard] = messageboard
    end

    def pad_post
      params[:topic][:posts_attributes]["0"][:messageboard] = messageboard
      params[:topic][:posts_attributes]["0"][:ip] = request.remote_ip
      params[:topic][:posts_attributes]["0"][:user] = current_user
    end

end
