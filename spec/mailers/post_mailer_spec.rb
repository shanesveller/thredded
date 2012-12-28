require 'spec_helper'

describe PostMailer, 'at_notification' do
  before do
    joel = build_stubbed(:user, name: 'joel')
    john = build_stubbed(:user, email: 'john@email.com')
    sam = build_stubbed(:user, email: 'sam@email.com')
    topic = build_stubbed(:topic, hash_id: 'abcd')
    site = build_stubbed(:site, email_from: 'no-reply@thredded.com',
      incoming_email_host: 'reply.thredded.com',
      email_subject_prefix: '[Thredded]')
    post = build_stubbed(:post, topic: topic, user: joel,
      content: 'hey @john @sam blarghy blurp')
    post.messageboard.stubs(:site).returns(site)
    users = [john, sam]
    @mail = PostMailer.at_notification(post, users)
  end

  it 'sets the correct headers' do
    @mail.from.should eq(['no-reply@thredded.com'])
    @mail.to.should eq(['no-reply@thredded.com'])
    @mail.bcc.should eq(['john@email.com','sam@email.com'])
    @mail.reply_to.should eq(['abcd@reply.thredded.com'])
    @mail.subject.should eq('[Thredded] Someone just mentioned you in a post.')
  end

  it 'renders the body' do
    @mail.body.encoded.should include('joel just mentioned you in a post')
    @mail.body.encoded.should include('hey @john @sam blarghy blurp')
  end
end
