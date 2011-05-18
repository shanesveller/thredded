# Setup ===============================


Given /^a new thread by "([^"]*)" named "([^"]*)" exists on "([^"]*)"$/ do |username, title, messageboard|
  u = User.where(:name => username).first || Factory(:user, :name => username, :email => "#{username}@email.com")
  m = Messageboard.where(:name => messageboard).first
  t = Factory :topic, :title => title, :messageboard => m, :user => u.name, :post_count => 1
end

Given /^the latest thread on "([^"]*)" has several posts$/ do |messageboard|
  Given %{a new thread by "joel" named "oh hello" exists on "#{messageboard}"}
  messageboard = Messageboard.where(:name => messageboard).first
  2.times do |index|
    messageboard.topics.latest.first.posts.create(:content => "post ##{index}", :user => "joel")
  end
  messageboard.topics.latest.first.save
end

Given /^the ([^"]*) post on the most recent thread is joels$/ do |position|
  latest_topic = Messageboard.first.topics.latest.first
  if "last" == position
    latest_topic.posts.last.user = "joel"
  elsif "first" == position
    latest_topic.posts.first.user = "joel"
  end
  latest_topic.save
end

Given /^the ([^"]*) post on the most recent thread is not joels/ do |position|
  latest_topic = Messageboard.first.topics.latest.first
  if "last" == position
    latest_topic.posts.last.user = "notjoel"
  elsif "first" == position
    latest_topic.posts.first.user = "notjoel"
  end
  latest_topic.save
end

# Assertions ==========================


When /^I click the edit subject link$/ do
  find_link("edit subject").click
end

Then /^I should be able to edit this thread$/ do
  page.should have_selector('form.edit_topic')
end

Then /^I should see only my original post$/ do
  page.should_not have_selector("textarea:nth-of-type(1)")
end

Then /^I should not be able to edit this thread$/ do
  page.should_not have_selector('form.edit_topic')
end

Then /^I should see an edit link for the ([^"]*) post$/ do |position|
  page.should have_selector("article:#{position} footer a.edit")
end

Then /^I should not see an edit link for the ([^"]*) post$/ do |position|
  page.should_not have_selector("article:#{position} footer a.edit")
end
