class TopicMailer < ActionMailer::Base
  def message_notification(topic, members)
    @topic = topic
    headers['X-SMTPAPI'] = %Q{{"category": ["thredded_#{topic.messageboard.name}","at_notification"]}}
    site = topic.messageboard.site
    reply_to = "#{topic.hash_id}@#{site.incoming_email_host}"
    bcc = members.map(&:email)
    no_reply = site.email_from
    subject = "#{site.email_subject_prefix} #{topic.title}"

    mail from: no_reply, to: no_reply, bcc: bcc, reply_to: reply_to, subject: subject
  end
end
