class PrivateTopic < Topic
  field :private, :type => Boolean
  references_many :users, :inverse_of => :private_topics
end
