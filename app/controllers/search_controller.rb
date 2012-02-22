class SearchController < ApplicationController

  def index
    @found_topics = TopicPostSearch.new( params[:q], messageboard.name)
    @topics = []
    @found_topics.each {|f| @topics.push f.topic}
  end

end
