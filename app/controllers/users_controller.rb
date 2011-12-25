class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @user = User.find_by_name(params[:id])
  end

  def index
    @users = User.all
  end
  
  def edit
    @user = User.find(params[:id])
  end

end
