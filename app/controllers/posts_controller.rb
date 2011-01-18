class PostsController < ApplicationController
  load_and_authorize_resource :only => [:index, :show, :edit]
  theme 'plainole'
  layout 'application'
  before_filter :pad_post, :only => :create

  # TODO: NEEDS SOME F#CKING CUKES.
  #
  def create
    p = topic.posts.create(params[:post])
    render :text => p.to_yaml
  end

  def update
    
  end

  # ======================================
 
  def messageboard
    @messageboard ||= Messageboard.where(:name => params[:messageboard_id]).first
  end

  def topic
    @topic ||= Topic.find(params[:topic_id])
  end

  def current_user_name 
    @current_user_name ||= current_user.nil? ? "anonymous" : current_user.name
  end

  # ======================================

  private

    def pad_post
      params[:post][:ip] = request.remote_ip
      params[:post][:user] = current_user_name
    end

end
