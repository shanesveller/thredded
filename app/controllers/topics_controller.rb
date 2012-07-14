class TopicsController < ApplicationController
  before_filter :pad_params,  :only => [:create, :update]
  before_filter :pad_post,    :only => :create
  before_filter :pad_topic,   :only => :create

  def index
    unless can? :read, messageboard
      redirect_to default_home,
        flash: { error: 'You are not authorized access to this messageboard.' }
    else
      @sticky = get_sticky_topics
      @topics = get_topics

      if on_search_page?
        redirect_if_no_search_results_for @topics
        render 'search'
      end
    end
  end

  def new
    @topic = messageboard.topics.build
    unless can? :create, @topic
      flash[:error] = "Sorry, you are not authorized to post on this messageboard."
      redirect_to messageboard_topics_url(messageboard, :host => @site.cached_domain)
    end
    @topic.type = "PrivateTopic" if params[:type] == "private"
    @topic.posts.build
  end

  def create
    @topic = klass.create(params[:topic])
    redirect_to messageboard_topics_url(messageboard, :host => @site.cached_domain)
  end

  def edit
    authorize! :update, topic
  end

  def update
    topic.update_attributes(params[:topic])
    redirect_to messageboard_topic_posts_url(messageboard, topic, :host => @site.cached_domain)
  end

  private

  def get_topics
    if params[:q].present?
      Topic.full_text_search(params[:q], messageboard.id) 
    else
      Topic.unstuck.where(messageboard_id: messageboard.id).order('updated_at DESC').page(params[:page]).per(30)
    end
  end

  def get_sticky_topics
    if on_first_topics_page?
      Topic.stuck.where(messageboard_id: messageboard.id).order('id DESC')
    else
      []
    end
  end

  def on_first_topics_page?
    (params[:page].nil? || params[:page] == '1') && !params[:q].present?
  end

  def on_search_page?
    params[:q].present?
  end

  def redirect_if_no_search_results_for(topics)
    if on_search_page? && topics.length == 0
      redirect_to messageboard_topics_path(messageboard), :flash => { :error => "No topics found for this search." } 
    end
  end

  def default_home
    root_url(:host => site.cached_domain)
  end

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
