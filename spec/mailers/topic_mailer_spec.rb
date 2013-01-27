require "spec_helper"

describe TopicMailer do
  describe "message_notification" do
    it 'sends the right message' do
      joel = build_stubbed(:user, name: 'joel')
      john = build_stubbed(:user, name: 'john', email: 'john@email.com')
      sam = build_stubbed(:user, name: 'sam', email: 'sam@email.com')
      topic = build_stubbed(:private_topic, title: 'Private message',
        users: [john, sam], user: joel, posts: [build_stubbed(:post)])
      site = build_stubbed(:site, email_from: 'no-reply@thredded.com',
        incoming_email_host: 'reply.thredded.com',
        email_subject_prefix: '[Thredded]')
      topic.messageboard.stubs(:site).returns(site)
      mail = TopicMailer.message_notification(topic, [john, sam])

      mail.subject.should eq "[Thredded] Private message"
      mail.to.should eq ["no-reply@thredded.com"]
      mail.from.should eq ['no-reply@thredded.com']
      mail.bcc.should eq ['john@email.com','sam@email.com']
      mail.body.encoded.should include('included you in a private topic')
    end
  end
end
