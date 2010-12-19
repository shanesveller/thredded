Then /^I should see a list of threads$/ do
  page.should have_css('#topics_listing')
end

Then /^I should see the main site homepage$/ do
  page.should have_css('#site_home')
end

When /^I set the default messageboard home to "([^"]*)"$/ do |board_home|
  THREDDED = Hash.new if THREDDED.nil?
  THREDDED[:default_messageboard_home] = board_home 
end

When /^I set the default messageboard to "([^"]*)"$/ do |board_name|
  THREDDED[:default_messageboard_name] = board_name 
end

Given /^a "([a-z\_]*)" messageboard exists named "([^"]*)"$/ do |security_type, board_name|
  messageboard = Factory :messageboard,
    :name                  => board_name,
    :security              => security_type.to_sym
end
