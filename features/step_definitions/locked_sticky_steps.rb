Given /^the thread is locked$/ do
  @topic.update_attribute(:locked, true)
end


Given /^the thread "([^"]*)" is sticky$/ do |title|
  @topic.find_by_title(title)
  @topic.update_attribute(:sticky, true)
end

Then /^the top\-most thread should be "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should not see the reply form$/ do
  pending # express the regexp above with the code you wish you had
end
