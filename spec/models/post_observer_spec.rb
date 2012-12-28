require 'spec_helper'

describe PostObserver, '#after_save' do
  it 'sends at notifications' do
    post = build_stubbed(:post)
    notifier = Notifier.new(post)
    notifier.stubs(notifications_for_at_users: true)
    Notifier.stubs(new: notifier)

    observer = PostObserver.instance
    observer.after_save(post)

    notifier.should have_received(:notifications_for_at_users)
  end
end
