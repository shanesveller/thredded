class PostMailer < ActionMailer::Base
  def at_notification(post, users)
    @post = post

    headers['X-SMTPAPI'] = %Q{{"category": ["thredded_#{post.messageboard.name}","at_notification"]}}
    site = post.messageboard.site
    reply_to = "#{post.topic.hash_id}@#{site.incoming_email_host}"
    bcc = users.map(&:email)
    no_reply = site.email_from
    subject = "#{site.email_subject_prefix} Someone just mentioned you in a post."

    mail(from: no_reply, to: no_reply, bcc: bcc, reply_to: reply_to, subject: subject)
  end
end
