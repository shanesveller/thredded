class TopicsController < ApplicationController
  before_filter :pad_params,  :only => [:create, :update]
  before_filter :pad_post,    :only => :create
  before_filter :pad_topic,   :only => :create

  def index
    unless site.present? and can? :read, messageboard
      redirect_to default_home, :flash => { :error => "You are not authorized access to this messageboard." } and return 
    end
    @topics = params[:q].present? ? Topic.full_text_search(params[:q], messageboard.id) : messageboard.topics
    redirect_to messageboard_topics_path(messageboard), :flash => { :error => "No topics found for this search." } unless @topics.length > 0
    @messageboards = site.messageboards
  end

  def new
    @topic = messageboard.topics.build
    unless can? :create, @topic
      flash[:error] = "Sorry, you are not authorized to post on this messageboard."
      redirect_to messageboard
    end
    @topic.type = "PrivateTopic" if params[:type] == "private"
    @topic.posts.build
  end

  def create
    @topic = klass.create(params[:topic])
    redirect_to messageboard_topics_path(messageboard, :host => @site.cached_domain)
  end

  def edit
    authorize! :update, topic
  end
 
  def update
    topic.update_attributes(params[:topic])
    redirect_to messageboard_topic_path(messageboard, topic)
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
