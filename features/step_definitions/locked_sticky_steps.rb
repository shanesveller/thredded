Given /^the thread is locked$/ do
  @topic.update_attribute(:locked, true)
end


Given /^the thread "([^"]*)" is sticky$/ do |title|
  @topic = Topic.where(title: title).first
  @topic.update_attribute(:sticky, true)
end

Then /^the top\-most thread should be "([^"]*)"$/ do |title|
  within(:css, "#content article:first h1 a") do
    page.should have_content(title)
  end
end

Then /^I should not see the reply form$/ do
  page.should_not have_css("#post_content")
end
