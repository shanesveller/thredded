class HomeController < ApplicationController

  def index
    # flash.now[:notice] = "hi"
    @users = User.all
  end

end
