class TopicsController < ApplicationController
  layout 'application'
  before_filter :pad_params,  :only => [:create, :update]
  before_filter :pad_post,    :only => :create
  before_filter :pad_topic,   :only => :create
  helper_method :site, :messageboard, :topic

  def index
    authorize! :index, messageboard, :message => "You are not authorized access to this messageboard."
    @topics = messageboard.topics
  end

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
    redirect_to link_for_messageboard(site, messageboard)
  end

  def edit
    authorize! :update, topic
  end
 
  def update
    topic.update_attributes(params[:topic])
    redirect_to messageboard_topic_path(messageboard, topic)
  end

  # ======================================
 
  # TODO : this feels wrong, really wrong.  this should get pulled out.
  def link_for_messageboard(site, messageboard)
    if %w{test}.include?( Rails.env )
      path = site_messageboards_path(site.slug, messageboard.name)
    else
      port = request.port == 3000 ? ":3000" : ""
      path = site_messageboards_path(messageboard.name)
      path = "http://#{site.slug}.#{request.host}#{port}#{path}"
    end
    path
  end

  def messageboard
    @messageboard ||= Messageboard.where(:name => params[:messageboard_id]).where(:site_id => site.id).first
  end

  def topic
    @topic ||= Topic.find_by_slug(params[:id])
  end

  def site 
    @site ||= Site.find_by_slug(params[:site_id])
  end

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
