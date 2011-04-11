When /^I click the edit subject link$/ do
  find_link("edit subject").click
end

Then /^I should be able to edit this thread$/ do
  page.should have_selector('form.edit_topic')
end

# ==========================

Given /^a new thread by "([^"]*)" named "([^"]*)" exists on "([^"]*)"$/ do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

Then /^I should not be able to edit this thread$/ do
  pending # express the regexp above with the code you wish you had
end

