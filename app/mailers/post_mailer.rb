class PostMailer < ActionMailer::Base
  def at_notification(post_id, user_emails)
    @post = Post.find(post_id)

    headers['X-SMTPAPI'] = %Q{{"category": ["thredded_#{@post.messageboard.name}","at_notification"]}}
    site = @post.messageboard.site
    reply_to = "#{@post.topic.hash_id}@#{site.incoming_email_host}"
    no_reply = site.email_from
    subject = "#{site.email_subject_prefix} #{@post.topic.title}"

    mail from: no_reply, to: no_reply, bcc: user_emails,
      reply_to: reply_to, subject: subject
  end
end
