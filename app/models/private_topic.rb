class PrivateTopic < Topic
  field :private, :type => Boolean
  references_many :users, :stored_as => :array, :inverse_of => :private_topics
end
