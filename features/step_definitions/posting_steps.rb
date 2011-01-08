Given /^a messageboard named "([^"]*)" that I, "([^"]*)", am a member of$/ do |messageboard, name|
  if !u = User.where(:name => name).first
    u = Factory :user,
      :name                  => name,
      :email                 => "email@email.com",
      :password              => "password",
      :password_confirmation => "password"
  end
  m = Factory :messageboard,
    :name                  => messageboard,
    :security              => :public
  u.member_of(m)
end

When /^I enter a title "([^"]*)" with content "([^"]*)"$/ do |title, content|
  fill_in "Title", :with => title
  fill_in "Content", :with => content
end

When /^I submit the form$/ do
  click_button "Create New Topic"
end

Given /^I create the following new topics:$/ do |topics_table|
  u = User.first
  m = Messageboard.first
  topics_table.hashes.each_with_index { |topic, i|
    # travel 10 seconds in the future so all new topics aren't at the same time
    Timecop.travel(Time.now.advance(:seconds => i*10))
    
    # create topics and posts
    t = m.topics.create(:last_user => u.name, :title => topic[:title], :messageboard => m, :user => u.name, :post_count => 1)
    t.posts.create(:content => topic[:content], :user => u.name)
  }
end

Then /^the topic listing should look like the following:$/ do |topics_table|
  topics_table.diff!(tableish('#topics header, #topics article','h1 a,.started_by a,.updated_by a,.post_count, div'))
  # topics_table.diff!(actual_table)
end

Given /^another member named "([^"]*)" exists$/ do |name|
  u = Factory :user,
    :name                  => name,
    :email                 => "#{name}@email.com",
    :password              => "password",
    :password_confirmation => "password"
end

When /^I enter a recipient named "([^"]*)", a title "([^"]*)" and content "([^"]*)"$/ do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

Given /^a private thread exists between "([^"]*)" and "([^"]*)" titled "([^"]*)"$/ do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

