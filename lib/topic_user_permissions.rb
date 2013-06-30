class TopicUserPermissions
  attr_reader :topic, :user, :messageboard

  def initialize(topic, user)
    @topic = topic
    @messageboard = topic.messageboard || Messageboard.new
    @user = user
  end

  def creatable?
    member? || messageboard_restrictions_allow?
  end

  def manageable?
    superadmin? || started_by_user? || administrates_messageboard?
  end

  def readable?
    MessageboardUserPermissions.new(messageboard, user).readable?
  end

  private

  def messageboard_restrictions_allow?
    user.valid? &&
      (messageboard.restricted_to_logged_in? || messageboard.posting_for_logged_in?)
  end

  def member?
    user.valid? && messageboard.has_member?(user)
  end

  def superadmin?
    user.superadmin?
  end

  def started_by_user?
    topic.user_id == user.id
  end

  def administrates_messageboard?
    user.valid? && messageboard.member_is_a?(user, 'admin')
  end
end
