module HomeHelper

  def messageboard_greeting
    if @messageboard
      @messageboard.name + " home"
    else
      "Welcome to "+THREDDED[:site_name]
    end
  end

end
