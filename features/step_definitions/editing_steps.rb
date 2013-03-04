Given /^a new thread by "([^"]*)" named "([^"]*)" exists on "([^"]*)"$/ do |username, title, messageboard|
  @user = User.where(name: username).first ||
    create(:user, name: "#{username}s", email: "#{username}s@example.com")
  @messageboard = Messageboard.where(name: messageboard).first
  @topic = create(:topic, title: title, messageboard: @messageboard,
    user: @user, last_user: @user)
  @post = create(:post, user: @user, topic: @topic)
end

Given /^"(.*?)" is in the "(.*?)" category$/ do |title, category|
  category = create(:category, name: category)
  messageboard = @topic.messageboard
  messageboard.categories << category
end

Given /^the latest thread on "([^"]*)" has several posts$/ do |messageboard|
  step %{a new thread by "joel" named "oh hello" exists on "#{messageboard}"}

  2.times do |index|
    @topic.posts.create(content: "post ##{index}", user: @user,
      messageboard: @messageboard)
  end

  @topic.save
end

Given /^the ([^"]*) post on the most recent thread is mine$/ do |position|
  post = @topic.posts.last if 'last' == position
  post = @topic.posts.first if 'first' == position
  post.user = @current_user
  post.save
end

Given /^the ([^"]*) post on the most recent thread is not mine/ do |position|
  @not_me = create(:user, name: 'notme', email: 'notme@email.com')

  post = @topic.posts.send(position.to_sym)
  post.user = @not_me
  post.save
end

Given /^the last post is formatted with "(.*?)"$/ do |filter|
  last_post = Post.last
  last_post.update_attribute(:filter, filter)
end

Then /^the selected post filter is "(.*?)"$/ do |filter|
  find('#post_filter').value.should eq filter
end

When /^I change the content to "([^"]*)"$/ do |content|
 fill_in 'Content', with: content
end

When /^I change the title to "([^"]*)"$/ do |title|
 fill_in 'Title', with: title
end

When /^I click the edit topic button$/ do
  find_button('Update Topic').click
end

When /^I click the edit subject link$/ do
  find('header .breadcrumbs a', text: 'edit').click
end

Then /^I should not see the content field$/ do
  page.should_not have_selector('form .content textarea')
end

Then /^I should be able to edit this thread$/ do
  page.should have_selector('form.topic_form')
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

When /^I click the edit link for the ([^"]*) post$/ do |position|
  find("article:#{position} footer a.edit").click
end

When /^I update it to "([^"]*)"$/ do |content|
  fill_in 'Content', with: content
  click_button 'Update Post'
end

Then /^I should see "([^"]*)" in the ([^"]*) post$/ do |content, position|
  within :css, "article:#{position} .content" do
    page.should have_content(content)
  end
end
