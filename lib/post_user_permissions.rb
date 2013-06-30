class PostUserPermissions
  attr_reader :post, :user, :messageboard, :topic

  def initialize(post, user)
    @post = post
    @topic = post.topic
    @messageboard = post.messageboard
    @user = user
  end

  def manageable?
    user.id == post.user_id || user.superadmin?
  end

  def creatable?
    !topic_locked?
  end

  def topic_locked?
    post_unsaved? && topic.try(:locked?)
  end

  private

  def post_unsaved?
    !post.persisted?
  end
end
