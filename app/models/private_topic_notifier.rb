class PrivateTopicNotifier
  def initialize(topic)
    @topic = topic
    @post = topic.posts.first || Post.new
  end

  def notifications_for_private_topic
    members = private_topic_recipients

    if members.present?
      TopicMailer.message_notification(@topic, members).deliver
      mark_notified(members)
    end
  end

  def private_topic_recipients
    members = @topic.users - [@topic.user]
    members = exclude_those_opting_out_of_message_notifications(members)
    members = exclude_previously_notified(members)
    members
  end

  private

  def mark_notified(members)
    members.each do |member|
      @post.post_notifications.create(email: member.email)
    end
  end

  def exclude_those_opting_out_of_message_notifications(members)
    members.reject do |member|
      !member.private_message_notifications_for?(@topic.messageboard)
    end
  end

  def exclude_previously_notified(members)
    emails_notified = @post.post_notifications.map(&:email)

    members.reject do |member|
      emails_notified.include? member.email
    end
  end
end
