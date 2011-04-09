class HomeController < ApplicationController
  theme 'beast'
  layout 'application'

  def index

    if @messageboard = Messageboard.first(:conditions => { :name => THREDDED[:default_messageboard_name] })
      if THREDDED[:default_messageboard_home] == 'topics' && @messageboard.security == :private && current_user.nil?
        flash[:alert] = "This messageboard is private. Please log in."
        redirect_to new_user_session_url
      elsif THREDDED[:default_messageboard_home] == 'topics' && @messageboard.security == :logged_in && current_user.nil?
        flash[:alert] = "This messageboard is public, but you must be logged in to see it."
        redirect_to new_user_session_url
      elsif THREDDED[:default_messageboard_home] == 'topics' || (@messageboard.security == :logged_in && current_user.present?)
        redirect_to topics_path(@messageboard)
      end
    end

  end
end
