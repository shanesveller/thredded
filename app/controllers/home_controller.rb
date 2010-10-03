class HomeController < ApplicationController

  def index
    @users = User.all
    @messageboard_name = params[:id].present? ? params[:id] : THREDDED[:default_messageboard_name]
  end

end