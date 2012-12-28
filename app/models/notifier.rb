class Notifier
  def initialize(post)
    @post = post
  end

  def notifications_for_at_users
    members = notifiable_members

    if members.present?
      PostMailer.at_notification(@post, members).deliver
      mark_notified(members)
    end
  end

  def notifiable_members
    emails_notified = @post.post_notifications.map(&:email)
    at_names = AtNotificationExtractor.new(@post.content).extract
    members = @post.messageboard.members_from_list(at_names).all

    members.delete @post.user
    members = exclude_previously_notified(members, emails_notified)
    members = exclude_those_that_are_not_private(members)

    members
  end

  private

  def exclude_those_that_are_not_private(members)
    members.reject do |member|
      @post.topic.private? && @post.topic.users.exclude?(member)
    end
  end

  def exclude_previously_notified(members, emails_notified)
    members.reject do |member|
      emails_notified.include? member.email
    end
  end

  def mark_notified(members)
    members.each do |member|
      @post.post_notifications.create(email: member.email)
    end
  end
end
