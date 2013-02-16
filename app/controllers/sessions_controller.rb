class SessionsController < Devise::SessionsController
  def create
    if env.key? 'omniauth.auth'
      identity = Identity.from_omniauth( env['omniauth.auth'] )
      sign_in identity.user
      session[:signed_in_with] = env['omniauth.auth']['provider']
      redirect_to root_path, flash: { notice: "You have logged in with an external service like GitHub, Facebook or Twitter and might have an account here already. If you would like to link your external service's identity with your existing account, then <a href='/users/edit'>visit your account page</a>." }
    else
      super
    end
  end
end
