RSpec.configure do |config|
  config.before do
    PrivateTopic.notification_enabled = false
    Post.notification_enabled = false

    notifiers = example.metadata[:notifiers] == true

    if notifiers
      PrivateTopic.notification_enabled = true
      Post.notification_enabled = true
    end
  end
end
