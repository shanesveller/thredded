class TopicsController < ApplicationController
  before_filter :pad_params, :only => [:create, :update]
  helper_method :messageboard, :topic

  def index
    @topics = Topic.all
  end

  def show
  end
  
  def new
    @topic = Topic.new
    @topic.posts.build
  end

  def create
    debugger
    @topic = messageboard.topics.new(params[:topic])
    @topic.posts << Post.new(params[:topic][:posts_attributes]["0"])
    @topic.posts.first.user = current_user.name
    @topic.posts.first.ip = request.remote_ip
    @topic.save!
    redirect_to messageboard_topics_path(messageboard)
  end

  def edit
  end
 
  def update
    # TODO
  end

  # ======================================
 
  def messageboard
    @messageboard ||= Messageboard.where(:name => params[:messageboard_id]).first
  end

  def topic
    @topic ||= Topic.find(params[:id])
  end

  # ======================================

  private

    def pad_params
      current_user_name = current_user.nil? ? "anonymous commenter" : current_user.name
      params[:topic][:user] = current_user_name
      params[:topic][:last_user] = current_user_name
    end

end
