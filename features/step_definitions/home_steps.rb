Then /^I should see the main homepage$/ do
  page.should have_css('#site_home')
end