class SettingsController < ApplicationController
  layout 'settings'
  helper_method :step

  def new
    case step
      when "1"
        @user = User.new
      when "2"
        @site = Site.new
      when "3"
        @messageboard = Messageboard.new
    end
  end

  def edit
  end

  def show
  end

  def create
    case step
    when "1"
      @user = User.create(params[:user]) 
      redirect_to '/2' if @user.valid?
      flash[:error] = "There were errors creating your user." and render :action => :new unless @user.valid?
    when "2"
      @user = User.last
      @site = Site.create params[:site].merge!({:user => @user})
      redirect_to '/3' if @site.valid?
    when "3"
      @user = User.last
      @site = Site.last
      @messageboard = Messageboard.create(params[:messageboard].merge!( {:theme => "default", :site => @site} ))
      @messageboard.topics.create( :user => @user, 
                                   :last_user => @user, 
                                   :title => "Welcome to your site's very first thread",
                                   :posts_attributes => {
                                     "0" => {
                                       :content => "There's not a whole lot here for now.", 
                                       :user => @user, 
                                       :ip => "127.0.0.1", 
                                       :messageboard => @messageboard
                                     }
                                   })
      debugger
      redirect_to root_path if @messageboard.valid?
    end
  end

  def update
  end

private

  def step
    @step ||= params[:step] || "1" 
  end

end

