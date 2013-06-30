class PrivateTopicUserPermissions
  attr_reader :private_topic, :user, :messageboard

  def initialize(private_topic, user)
    @private_topic = private_topic
    @messageboard = private_topic.messageboard
    @user = user
  end

  def listable?
    user.private_topics.any?
  end

  def manageable?
    user_started_topic?
  end

  def readable?
    private_topic.users.include?(user)
  end

  def creatable?
    TopicUserPermissions
      .new(private_topic, user).creatable?
  end

  private

  def user_started_topic?
    user.id == private_topic.user_id
  end
end
