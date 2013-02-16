class IdentitiesController < ApplicationController
  def update
    provider = session[:signed_in_with]

    if user_exists?
      link_existing_user_to_current_identity
      clear_out_session_var

      redirect_to :back, flash: { error: "Your #{provider.capitalize} account is now linked to #{existing_user.email}." }
    else
      redirect_to :back, flash: { error: 'Email or password are incorrect.' }
    end
  end

  private

  def link_existing_user_to_current_identity
    identity = current_user.identities.where(provider: session[:signed_in_with]).first
    identity.update_attributes(user: existing_user)
  end

  def existing_user
    @existing_user ||= User.where(email: params[:identity][:email]).first
  end

  def user_exists?
    existing_user.valid_password?(params[:identity][:password])
  end

  def clear_out_session_var
    session[:signed_in_with] = nil
  end
end
