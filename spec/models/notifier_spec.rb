require 'spec_helper'

describe Notifier, '#notifiable_members' do
  before do
    sam  = create(:user, name: 'sam')
    @joel = create(:user, name: 'joel', email: 'joel@example.com')
    @john = create(:user, name: 'john', email: 'john@example.com')
    @post = create(:post, user: sam, content: 'hey @joel and @john. - @sam')
    @joel.member_of @post.messageboard
    @john.member_of @post.messageboard
    sam.member_of @post.messageboard
  end

  it 'returns 2 users mentioned, not including post author' do
    notifier = Notifier.new(@post)
    notifiable_members = notifier.notifiable_members

    notifiable_members.should have(2).items
    notifiable_members.should include @joel
    notifiable_members.should include @john
  end

  it 'does not return any users already emailed about this post' do
    prev_notifications = create(:post_notification, post: @post,
      email: 'joel@example.com')
    notifier = Notifier.new(@post)

    notifier.notifiable_members.should have(1).item
    notifier.notifiable_members.should include @john
  end

  it 'does not return users not included in a private topic' do
    @post.topic = create(:private_topic, user: @post.user,
      last_user: @post.user, messageboard: @post.messageboard, users: [@joel])
    notifier = Notifier.new(@post)

    notifier.notifiable_members.should have(1).item
    notifier.notifiable_members.should include @joel
  end
end

describe Notifier, '#notifications_for_at_users' do
  before do
    sam  = create(:user, name: 'sam')
    @joel = create(:user, name: 'joel', email: 'joel@example.com')
    @john = create(:user, name: 'john', email: 'john@example.com')
    @post = create(:post, user: sam, content: 'hey @joel and @john. - @sam')
    @post.messageboard.site = create(:site)
    @joel.member_of @post.messageboard
    @john.member_of @post.messageboard
    sam.member_of @post.messageboard
  end

  it 'does not notify any users already emailed about this post' do
    notifier = Notifier.new(@post)
    notifier.notifications_for_at_users
    notified_emails = @post.post_notifications.map(&:email)

    notified_emails.should have(2).items
    notified_emails.should include('joel@example.com')
    notified_emails.should include('john@example.com')
  end
end
