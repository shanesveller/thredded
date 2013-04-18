module HomeHelper
  def messageboard_greeting
    if @messageboard
      "#{@messageboard.name} home"
    else
      "Welcome to #{app_config.title}"
    end
  end
end
