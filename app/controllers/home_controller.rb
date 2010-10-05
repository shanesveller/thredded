class HomeController < ApplicationController

  def index
    if params[:id]
      @messageboard = Messageboard.first(:conditions => { :name => params[:id] })
    else
      @messageboard = Messageboard.first(:conditions => { :name => THREDDED[:default_messageboard_name] })
    end
    @messageboard_name = @messageboard.name

    if THREDDED[:default_messageboard_home] == 'topics' && @messageboard.security == :private && current_user.nil?
      flash[:alert] = "This messageboard is private. Please log in."
      redirect_to new_user_session_url
    elsif THREDDED[:default_messageboard_home] == 'topics' && @messageboard.security == :logged_in && current_user.nil?
      flash[:alert] = "This messageboard is public, but you must be logged in to see it."
      redirect_to new_user_session_url
    elsif THREDDED[:default_messageboard_home] == 'topics' || (@messageboard.security == :logged_in && current_user.present?)
      render 'messageboard/index'
    end

  end

end
