Given /^the default "([^"]*)" website domain is "([^"]*)"$/ do |permission, website|
  @site = Factory(:site, :domain => website, :permission => permission)
end

Given /^I visit "([^"]*)"$/ do |domain|
  Capybara.default_host = domain #for Rack::Test
# Capybara.app_host = "http://#{domain}:9887" if Capybara.current_driver == :selenium 
end

Given /^the default website has two messageboards named "([^"]*)" and "([^"]*)"$/ do |arg1, arg2|
  # debugger
end

Then /^I should see messageboards "([^"]*)" and "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Given /^a subdomain site exists called "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Given /^"([^"]*)" has two messageboards named "([^"]*)" and "([^"]*)"$/ do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

Given /^a custom domain site exists called "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should see the login form$/ do
  pending # express the regexp above with the code you wish you had
end

