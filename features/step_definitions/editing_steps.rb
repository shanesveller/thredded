When /^I click the edit subject link$/ do
  find_link("edit subject").click
end

Then /^I should be able to edit this thread$/ do
  page.should have_selector('form.edit_topic')
end

# ==========================

Given /^a new thread by "([^"]*)" named "([^"]*)" exists on "([^"]*)"$/ do |username, title, messageboard|
  u = Factory :user,
      :name                  => username,
      :email                 => "#{username}@email.com",
      :password              => "password",
      :password_confirmation => "password"
  m = Messageboard.where(:name => messageboard).first
#  m = Factory :messageboard, :name => messagboard, :security => :public
  t = Factory :topic, :title => title, :messageboard => m, :user => u.name, :post_count => 1
end

Then /^I should not be able to edit this thread$/ do
  page.should_not have_selector('form.edit_topic')
end

