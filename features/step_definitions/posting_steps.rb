Then /^I should not see the post reply form$/ do
  page.should_not have_selector('textarea#post_content')
end


Given /^"([^"]*)" posting permissions are constrained to those that are "([^"]*)"$/ do |messageboard, permission|
  @messageboard = Messageboard.find_by_name messageboard
  @messageboard.update_attribute(:posting_permission, permission)
end

Given /^a messageboard named "([^"]*)" that I, "([^"]*)", am an? "([^"]*)" of$/ do |messageboard, name, role|
  if !u = User.where(name: name).first
    u = create :user,
      name:                  name,
      email:                 "email@email.com",
      password:              "password",
      password_confirmation: "password"
  end
  m = create :messageboard, name: messageboard
  u.send "#{role}_of".to_sym, m
end

Given /^My post filter preference is "([^"]*)"$/ do |filter|
  @current_user.post_filter = filter
  @current_user.save!
end

Then /^The filter at the reply form should default to "([^"]*)"$/ do |filter|
  field_labeled("post_filter").value.should == filter
end

When /^I enter a title "([^"]*)" with content "([^"]*)"$/ do |title, content|
  fill_in "Title", with: title
  fill_in "Content", with: content
end

When /^I submit the form$/ do
  find('.submit input').click
end

Given /^a thread already exists on "([^"]*)"$/ do |board|
  u = User.last
  m = Messageboard.where(name: board).first
  t = m.topics.create(last_user: u, title: "thready thread", user: u, post_count: 1)
  t.posts.create(content: "FIRST!", user: u, messageboard: m)
end

When /^I submit some drivel like "([^"]*)"$/ do |content|
  fill_in "post_content", with: content
  click_button "Submit"
end

Given /^I create the following new threads:$/ do |topics_table|
  u = User.last
  m = Messageboard.first
  topics_table.hashes.each_with_index { |topic, i|
    # travel 10 seconds in the future so all new topics aren't at the same time
    Timecop.travel(Time.now.advance(seconds: i*10))

    # create topics and posts
    t = m.topics.create(last_user: u, title: topic[:title], messageboard: m, user: u, post_count: 1)
    p = t.posts.create(content: topic[:content], user: u, messageboard: m)
  }
end

Then /^the topic listing should look like the following:$/ do |topics_table|
  html = Capybara::Node::Simple.new(body)
  cells = html.
    all('#content article h1 a, #content article .post_count, #content article .started_by a, #content article .updated_by a, #content article div').
    map(&:text).
    collect_every(4)
  table = cells.insert(0, ['Posts','Topic Title','Started','Updated'])
  topics_table.diff!(table)
end

Given /^another member named "([^"]*)" exists$/ do |name|
  u = User.create(name:                  name,
                  email:                 "#{name}@email.com",
                  password:              "password",
                  password_confirmation: "password")
end

Given /^"([^"]*)" is a member of "([^"]*)"$/ do |name, board|
  u = User.find_by_name(name)
  m = Messageboard.find_by_name(board)
  u.member_of m
end

Given /^I am a admin of "([^"]*)"$/ do |board|
  user = User.last
  board = Messageboard.find_by_name board
  user.member_of board, "admin"
end


When /^I enter a recipient named "([^"]*)", a title "([^"]*)" and content "([^"]*)"$/ do |username, title, content|
  select username, from: 'topic_user_id'
  step %{I enter a title "#{title}" with content "#{content}"}
end

Given /^a private thread exists between "([^"]*)" and "([^"]*)" titled "([^"]*)"$/ do |user1, user2, title|
  @user1 = create(:user, name: user1, email: "#{user1}@thredded.com")
  @user2 = create(:user, name: user2, email: "#{user2}@thredded.com")
  @topic = create(:private_topic, messageboard: Messageboard.first,
    title: title, last_user: @user1, user: @user1, users: [@user1, @user2],
    posts: [create(:post)])
end
