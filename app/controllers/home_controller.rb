class HomeController < ApplicationController
  layout 'application'

  def index
    @messageboard = Messageboard.first(:conditions => { :name => THREDDED[:default_messageboard_name] }) 

    # TODO: Extract all this out to the Messageboard model
    #
    if @messageboard && @messageboard.default_home_is_topics?
      # ---------
      if @messageboard.restricted_to_private? && current_user.nil?
        flash[:alert] = "This messageboard is private. Please log in." and redirect_to new_user_session_url

      elsif @messageboard.restricted_to_logged_in? && current_user.nil?
        flash[:alert] = "This messageboard is public, but you must be logged in to see it." and redirect_to new_user_session_url

      elsif @messageboard.restricted_to_private? && current_user.present? && current_user.member_of?(@messageboard)
        redirect_to topics_path(@messageboard)

      elsif @messageboard.restricted_to_logged_in? && current_user.present? 
        redirect_to topics_path(@messageboard)

      elsif @messageboard.public?
        redirect_to topics_path(@messageboard)

      end
      # ---------
    end
  end

end
