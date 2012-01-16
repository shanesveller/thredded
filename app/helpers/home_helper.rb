module HomeHelper

  def messageboard_greeting
    if @messageboard
      @messageboard.name + " home"
    else
      "Welcome to "+ default_site.title
    end
  end

end
