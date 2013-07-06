class PrivateTopic < Topic
  has_many :private_users
  has_many :users, through: :private_users
  attr_accessible :user_id
  cattr_accessor(:notification_enabled) { true }

  def create_or_update
    super &&
    notify_with_an_email
  end

  def add_user(user)
    if String == user.class
      user = User.find_by_name(user)
    end

    users << user
  end

  def public?
    false
  end

  def private?
    true
  end

  def self.for_user(user)
    joins(:private_users)
      .where(private_users: {user_id: user.id})
  end

  def user_id=(ids)
    if ids.size > 0
      self.users = User.where(id: ids.uniq)
    end
  end

  def users_to_sentence
    users.map{ |user| user.name.capitalize }.to_sentence
  end

  private

  def notify_with_an_email
    if self.notification_enabled
      PrivateTopicNotifier.new(self).notifications_for_private_topic
    else
      true
    end
  end
end
