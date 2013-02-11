class SessionsController < Devise::SessionsController
  def create
    if env.key? 'omniauth.auth'
      identity = Identity.from_omniauth( env['omniauth.auth'] )
      sign_in identity.user
      redirect_to default_home
    else
      super
    end
  end
end
