class TopicMailer < ActionMailer::Base
  def message_notification(topic_id, emails)
    @topic = Topic.find(topic_id)
    headers['X-SMTPAPI'] = %Q{{"category": ["thredded_#{@topic.messageboard.name}","at_notification"]}}
    reply_to = "#{@topic.hash_id}@#{config.incoming_email_host}"
    no_reply = config.email_from
    subject = "#{config.email_subject_prefix} #{@topic.title}"

    mail from: no_reply, to: no_reply, bcc: emails,
      reply_to: reply_to, subject: subject
  end

  private

  def config
    @config ||= AppConfig.first
  end
end
