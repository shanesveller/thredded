class PostMailer < ActionMailer::Base
  def at_notification(post_id, user_emails)
    @post = Post.find(post_id)
    no_reply = config.email_from
    subject = "#{config.email_subject_prefix} #{@post.topic.title}"
    reply_to = "#{@post.topic.hash_id}@#{config.incoming_email_host}"
    headers['X-SMTPAPI'] = %Q{{"category": ["thredded_#{@post.messageboard.name}","at_notification"]}}

    mail from: no_reply, to: no_reply, bcc: user_emails, reply_to: reply_to, subject: subject
  end

  private

  def config
    @config ||= AppConfig.first
  end
end
