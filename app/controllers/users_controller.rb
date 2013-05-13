class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User
      .where('lower(name) = ?', params[:id].downcase)
      .includes(:topics).first

    if @user.nil?
      error = "No user exists named #{params[:id]}"
      redirect_to root_path, flash: { error: error }
    else
      @recent_topics = @user.topics.recent
    end
  end
end
