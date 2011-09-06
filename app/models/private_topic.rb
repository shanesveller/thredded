class PrivateTopic < Topic
  has_many :private_users
  has_many :users, :through => :private_users
  attr_accessible :user_id

  def user_id=(ids)
    if ids.size > 0
      self.users = User.where(:id => ids.uniq)
    end
  end

end
