# Setup ===============================


Given /^a new thread by "([^"]*)" named "([^"]*)" exists on "([^"]*)"$/ do |username, title, messageboard|
  @user = User.where(:name => username).first || Factory(:user, :name => username+"s", :email => "#{username}s@email.com")
  @messageboard = Messageboard.where(:name => messageboard).first
  @topic = Factory :topic, :title => title, :messageboard => @messageboard, :user => @user, :last_user => @user
end

Given /^the latest thread on "([^"]*)" has several posts$/ do |messageboard|
  step %{a new thread by "joel" named "oh hello" exists on "#{messageboard}"}
  2.times do |index|
    @topic.posts.create(:content => "post ##{index}", :user => @user, :messageboard => @messageboard)
  end
  @topic.save
end

Given /^the ([^"]*) post on the most recent thread is mine$/ do |position|
  post = @topic.posts.last if "last" == position
  post = @topic.posts.first if "first" == position
  post.user = @current_user
  post.save
end

Given /^the ([^"]*) post on the most recent thread is not mine/ do |position|
  @not_me = Factory(:user, :name => "notme", :email => "notme@email.com")
  if "last" == position
    @topic.posts.last.user = @not_me
  elsif "first" == position
    @topic.posts.first.user = @not_me
  end
  @topic.save
end

When /^I change the content to "([^"]*)"$/ do |content|
 fill_in "Content", :with => content
end

When /^I click the edit topic button$/ do
  find_button("Edit Topic").click
end

When /^I click the edit subject link$/ do
  find_link("edit subject").click
end

# Assertions ==========================

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
