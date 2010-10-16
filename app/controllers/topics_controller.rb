class TopicsController < ApplicationController

  def index
    @topic =  Topic.all
  end

  def show
    @topic = Topic.where(:name => params[:id]).first
  end
  
  def new
    @messageboard = Messageboard.where(:name => params[:messageboard_id]).first
    @topic = Topic.new
  end

  def create
    @messageboard = Messageboard.where(:name => params[:messageboard_id]).first
    @topic = @messageboard.topics.create(params[:topic])
    redirect_to messageboard_topics_path(@messageboard)
  end
 
  private

    def pad_params
      params[:topic][:user] = current_user.name
      params[:topic][:last_user] = current_user.name
    end

end

