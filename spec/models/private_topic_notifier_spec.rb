require 'spec_helper'

describe PrivateTopicNotifier, '#notifications_for_private_topic' do
  it 'emails the recipients' do
    topic = build_stubbed(:private_topic)
    notifier = PrivateTopicNotifier.new(topic)
    notifier.stubs(private_topic_recipients: members, mark_notified: true)
    email = mock('email')
    email.stubs(deliver: true)
    TopicMailer.stubs(message_notification: email)

    notifier.notifications_for_private_topic

    expect(TopicMailer).to have_received(:message_notification)
      .with(topic.id, members.map(&:email))
  end

  def members
    [
      build_stubbed(:user, email: 'j@example.com'),
      build_stubbed(:user, email: 's@example.com'),
    ]
  end
end

describe PrivateTopicNotifier, '#private_topic_recipients' do
  it 'returns everyone but the sender' do
    john = build_stubbed(:user)
    joel = build_stubbed(:user)
    sam  = build_stubbed(:user)
    post = build_stubbed(:post, post_notifications: [])

    private_topic = build_stubbed(:private_topic,
      user: john,
      users: [john, joel, sam],
      posts: [post],
    )

    recipients = PrivateTopicNotifier
      .new(private_topic)
      .private_topic_recipients

    expect(recipients).to eq [joel, sam]
  end

  it 'excludes anyone whose preferences say not to notify' do
    post = build_stubbed(:post, post_notifications: [])
    john = build_stubbed(:user)
    sam  = build_stubbed(:user)
    joel = build_stubbed(:user)
    joel.stubs(private_message_notifications_for?: false)

    private_topic = build_stubbed(:private_topic,
      user: john,
      users: [john, joel, sam],
      posts: [post],
    )

    recipients = PrivateTopicNotifier
      .new(private_topic)
      .private_topic_recipients

      expect(recipients).to eq [sam]
  end

  it 'excludes anyone who has already been notified' do
    john = build_stubbed(:user)
    sam  = build_stubbed(:user)
    joel = build_stubbed(:user, email: 'joel@example.com')
    prev_notification = build_stubbed(:post_notification, email: 'joel@example.com')
    post = build_stubbed(:post, post_notifications: [prev_notification])

    private_topic = build_stubbed(:private_topic,
      user: john,
      posts: [post],
      users: [john, joel, sam]
    )

    recipients = PrivateTopicNotifier
      .new(private_topic)
      .private_topic_recipients

    expect(recipients).to eq [sam]
  end

  it 'marks the right users as modified' do
    create(:app_config)
    joel = create(:user, email: 'joel@example.com')
    sam = create(:user, email: 'sam@example.com')
    john = create(:user)
    messageboard = create(:messageboard)
    private_topic = create(:private_topic,
      user: john,
      users: [john, joel, sam],
      messageboard: messageboard
    )
    create(:post, content: 'hi', topic: private_topic)

    PrivateTopicNotifier.new(private_topic).notifications_for_private_topic

    expect(emails_for(private_topic)).to eq ['sam@example.com', 'joel@example.com']
  end

  def emails_for(private_topic)
    private_topic
      .posts
      .first
      .post_notifications
      .map(&:email)
  end
end
