require 'spec_helper'

describe PrivateTopic, '#create_or_update' do
  it 'sends notification of the private topic', notifiers: true do
    notifier = stub_private_topic_and_notifier
    topic = create(:private_topic)

    expect(PrivateTopicNotifier).to have_received(:new).with(topic)
    expect(notifier).to have_received(:notifications_for_private_topic)
  end

  def stub_private_topic_and_notifier
    private_topic = build_stubbed(:private_topic)
    notifier = PrivateTopicNotifier.new(private_topic)
    notifier.stubs(notifications_for_private_topic: true)
    PrivateTopicNotifier.stubs(new: notifier)

    notifier
  end
end

describe PrivateTopic, '#private?' do
  it 'is private when it has users' do
    topic = build_stubbed(:private_topic)

    expect(topic).to be_private
  end
end

describe PrivateTopic, '#users_to_sentence' do
  it 'lists users in a private topic in a human readable format' do
    user1 = build_stubbed(:user, name: 'privateuser1')
    user2 = build_stubbed(:user, name: 'privateuser2')
    topic = build_stubbed(:private_topic, users: [user1, user2])

    expect(topic.users_to_sentence).to eq 'Privateuser1 and Privateuser2'
  end
end

describe PrivateTopic, '#add_user' do
  it 'adds a user by their username' do
    topic = create(:private_topic)
    joel  = create(:user, name: 'joel')

    topic.add_user('joel')

    expect(topic.users).to include joel
  end

  it 'adds a user with a User object' do
    topic = create(:private_topic)
    joel  = create(:user, name: 'joel')

    topic.add_user(joel)

    expect(topic.users).to include joel
  end
end
