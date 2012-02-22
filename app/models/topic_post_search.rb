class TopicPostSearch < ActiveRecord::Base
    
  # We want to reference various models
  belongs_to :topic
  attr_accessible :topic

  # Wish we could eliminate n + 1 query problems,
  # but we can't include polymorphic models when
  # using scopes to search in Rails 3
  # default_scope :include => 
    
  # Search.new('query') to search for 'query'
  # across searchable models
  def self.new(query, board)
    query = query.to_s
    return [] if query.empty?
    @topics = self.search(:content => query, :messageboard_id => board) #.map!(|t| Topic.new(t.topic_id))
    @topics.uniq {|x| x.topic_id }
  end
    
  # Search records are never modified
  def readonly?; true; end

  # Our view doesn't have primary keys, so we need
  # to be explicit about how to tell different search
  # results apart; without this, we can't use :include
  # to avoid n + 1 query problems
  def hash; [topic_id].hash; end

  def eql?(result)
    topic_id == result.topic_id
  end
  
end
