class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.where('lower(name) = ?', params[:id].downcase).first

    unless @user
      redirect_to root_path,
        flash: { error: "No user exists named #{params[:id]}" }
    end
  end
end
