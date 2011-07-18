class PrivateTopic < Topic
  # field :private, :type => Boolean
  has_many :users
end
