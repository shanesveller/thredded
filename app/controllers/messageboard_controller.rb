class MessageboardController < ApplicationController

  def index
    @messageboard = Messageboard.find(params[:id])
    @messageboard_name = @messageboard.present? ? @messageboard.name : THREDDED[:default_messageboard_name]
  end

end
