Given /^a messageboard named "([^"]*)" that I, "([^"]*)", am an? "([^"]*)" of$/ do |messageboard, name, role|
  if !u = User.where(:name => name).first
    u = Factory :user,
      :name                  => name,
      :email                 => "email@email.com",
      :password              => "password",
      :password_confirmation => "password"
  end
  m = Factory :messageboard, :name => messageboard
  u.send "#{role}_of".to_sym, m
end

When /^I enter a title "([^"]*)" with content "([^"]*)"$/ do |title, content|
  fill_in "Title", :with => title
  fill_in "Content", :with => content
end

When /^I submit the form$/ do
  click_button "Create New Topic"
end

Given /^a thread already exists on "([^"]*)"$/ do |board|
  u = User.last
  m = Messageboard.where(:name => board).first
  t = m.topics.create(:last_user => u, :title => "thready thread", :user => u, :post_count => 1)
  t.posts.create(:content => "FIRST!", :user => u)
end

When /^I submit some drivel like "([^"]*)"$/ do |content|
  fill_in "post_content", :with => content
  click_button "Submit"
end

Given /^I create the following new threads:$/ do |topics_table|
  u = User.last
  m = Messageboard.first
  topics_table.hashes.each_with_index { |topic, i|
    # travel 10 seconds in the future so all new topics aren't at the same time
    Timecop.travel(Time.now.advance(:seconds => i*10))
    
    # create topics and posts
    t = m.topics.create(:last_user => u, :title => topic[:title], :messageboard => m, :user => u, :post_count => 1)
    p = t.posts.create(:content => topic[:content], :user => u, :messageboard => m)
  }
end

Then /^the topic listing should look like the following:$/ do |topics_table|
  topics_table.diff!(tableish('#content header, #content article','h1 a,.post_count,.started_by a,.updated_by a, div'))
end

Given /^another member named "([^"]*)" exists$/ do |name|
  u = User.create(:name                  => name,
                  :email                 => "#{name}@email.com",
                  :password              => "password",
                  :password_confirmation => "password")
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
  select username, :from => 'topic_user_id'
  And  %{I enter a title "#{title}" with content "#{content}"}
end

Given /^a private thread exists between "([^"]*)" and "([^"]*)" titled "([^"]*)"$/ do |user1, user2, title|
  @user1 = Factory(:user, :name => user1, :email => "#{user1}@thredded.com")
  @user2 = Factory(:user, :name => user2, :email => "#{user2}@thredded.com")
  @topic = Factory(:private_topic, :messageboard => Messageboard.first, :title => title, :last_user => @user1, :user => @user1, :users => [@user1, @user2])
end
