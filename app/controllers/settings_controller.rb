class SettingsController < ApplicationController
  layout 'settings'

  def new
    @step = params[:step] || "1" 

    case @step
      when "1"
        @user = User.new
      when "2"
        @site = Site.new
      when "3"
        @messageboard = Messageboard.new
      when "4"
        @setting = Setting.new
    end
  end

  def edit
  end

  def show
  end

  def create
    case params[:step]
    when "1"
      @user = User.create(params[:user]) 
      redirect_to root_path :step => 2 if @user.valid?
      render :action => :new unless @user.valid?
    when "2"
      debugger
    end
  end

  def update
  end

end
