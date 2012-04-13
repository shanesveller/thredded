class Admin::UsersController < ApplicationController
  load_and_authorize_resource

  def edit
    @user = User.find(params[:id])
  end

  def update
    if params[:user][:password].present? and params[:user][:password_confirmation].present?
      @user.update_attributes params[:user]
    else
      @user.update_without_password params[:user]
    end
    redirect_to edit_admin_site_user_path(site.id, @user.id)
  end
end
