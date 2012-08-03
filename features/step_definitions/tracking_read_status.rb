Given /^"([^"]*)" threads already exist on "([^"]*)"$/ do |thread_count, board|
  messageboard = Messageboard.find_by_name(board)
  user = User.first
  thread_count.to_i.times do
    topic = create(:topic, messageboard: messageboard, user: user, last_user: user)
    post = create(:post, topic: topic, user: user)
  end
end

Given /^I have read them all$/ do
  user = User.first
  Topic.all.each do |topic|
    create(:user_topic_read, topic_id: topic.id, user_id: user.id,
      post_id: topic.posts.last.id, posts_count: topic.posts.count)
  end
end

When /^someone responds to the oldest topic$/ do
  create(:post, topic: Topic.last, user: User.last)
end

Then /^the first topic should be unread$/ do
  within(:css, ".topics") do
    page.should have_selector('article:first a.unread')
  end
end

Then /^the second topic should be read$/ do
  within(:css, ".topics") do
    page.should have_selector('article:nth-child(2) a.read')
  end
end
