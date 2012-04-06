class Admin::UsersController < ApplicationController
  load_and_authorize_resource

  def edit 
  end

  def update
    # @roles_params = params[:user].delete(:roles_attributes)
    if @user.update_without_password params[:user]
      # unless @roles_params.nil?
      #   @roles_params.each do |role|
      #     @role = Role.new(:level => "member")
      #     @role.user_id = @user.id
      #     @role.messageboard_id = role[:messageboard_id]
      #     @role.save
      #   end
      # end
    end
    redirect_to edit_admin_site_user_path(site.id, @user.id)
  end
end
