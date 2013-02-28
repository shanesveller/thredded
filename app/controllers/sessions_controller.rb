class SessionsController < Devise::SessionsController
  def create
    if omniauth? && has_an_email?
      identity = Identity.from_omniauth(omniauth_hash)

      if identity
        remember_provider
        sign_in identity.user
        clear_out_session_variables
        redirect_to home_or_origin_path, flash: { notice: notice_msg }
      end

    elsif omniauth?
      remember_omniauth_env
      render_email_form

    else
      assign_redirect_after_sign_in
      super
    end
  end

  private

  def clear_out_session_variables
    session.delete 'omniauth.origin'
    session.delete 'omniauth.auth'
  end

  def remember_provider
    session[:signed_in_with] = omniauth_hash['provider']
  end

  def assign_redirect_after_sign_in
    if params['after_sign_in_redirect']
      session[:redirect_url] = params['after_sign_in_redirect']
    end
  end

  def home_or_origin_path
    if omniauth_origin.include? 'users/sign_in'
      root_path
    else
      omniauth_origin
    end
  end

  def remember_omniauth_env
    session['omniauth.origin'] = env['omniauth.origin']
    session['omniauth.auth'] = env['omniauth.auth']
  end

  def render_email_form
    flash[:error] = error_msg
    render 'provide_email'
  end

  def omniauth_origin
    env['omniauth.origin'] || session['omniauth.origin'] || {}
  end

  def omniauth_hash
    @omniauth_hash = env['omniauth.auth'] || session['omniauth.auth'] || {}
  end

  def omniauth?
    omniauth_hash.present?
  end

  def has_an_email?
    if params[:user] && params[:user][:email].present? && omniauth?
      @omniauth_hash.deep_merge!({
        'info' => {
          'email' => params[:user][:email]
        }
      })
    end

    omniauth_hash['info']['email'] &&
      omniauth_hash['info']['email'].present?
  end

  def error_msg
    "You have no email set at #{omniauth_hash['provider']}. Let us know what your
    email is so we can create your account."
  end

  def notice_msg
    <<-EOC.strip_heredoc.html_safe
      You have logged in with an external service like GitHub, Facebook or
      Twitter and might have an account here already. If you would like to
      link your external service's identity with your existing account, then
      <a href='/users/edit'>visit your account page</a>.
    EOC
  end
end
