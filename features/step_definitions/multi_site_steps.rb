Given /^there is a messageboard named "([^"]*)"$/ do |messageboard|
  @app_config ||= create(:app_config)
  create(:messageboard, name: messageboard, title: messageboard)
end

Given /^there are two messageboards named "([^"]*)" and "([^"]*)"$/ do |messageboard1, messageboard2|
  step %{there is a messageboard named "#{messageboard1}"}
  step %{there is a messageboard named "#{messageboard2}"}
end

Then /^I should see the homepage$/ do
  page.should have_selector('body#site_home')
end

Then /^I should see the messageboard called "([^"]*)"$/ do |messageboard|
  page.should have_selector('.messageboard header h2', text: messageboard)
end

Then /^I should see messageboards "([^"]*)" and "([^"]*)"$/ do |messageboard1, messageboard2|
  step %{I should see the messageboard called "#{messageboard1}"}
  step  %{I should see the messageboard called "#{messageboard2}"}
end

Then /^I should see the login form$/ do
  page.should have_selector('form#new_user')
end

Then /^I should not see the login form$/ do
  page.should_not have_selector('form#new_user')
end
