class PrivateTopic < Topic
  has_many :private_users
  has_many :users, :through => :private_users


  def add_user(name_or_obj)
    if name_or_obj.class == String
      @user = User.where(:name => name_or_obj).first
    elsif name_or_obj.class == User
      @user = name_or_obj
    end

    users << @user
  end

end
