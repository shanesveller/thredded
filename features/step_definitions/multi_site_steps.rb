Given /^the default "([^"]*)" website domain is "([^"]*)"$/ do |permission, website|
  @site ||= Factory(:site, 
                    :cname_alias => website, 
                    :permission => permission, 
                    :default_site => 't')
end

Given /^I visit "([^"]*)"$/ do |domain|
  @site = Site.find_by_cached_domain(domain)
  visit root_url(:host => @site.cached_domain)
end

Given /^the default website has a messageboard named "([^"]*)"$/ do |messageboard|
  @site = Site.find_by_default_site(true)
  @site.messageboards << Factory(:messageboard, :name => messageboard, :title => messageboard)
  @site.save
end

Given /^the default website has two messageboards named "([^"]*)" and "([^"]*)"$/ do |messageboard1, messageboard2|
  step %{the default website has a messageboard named "#{messageboard1}"}
  step %{the default website has a messageboard named "#{messageboard2}"}
end

Given /^the default website home is the homepage$/ do
  @site.home = "homepage"
  @site.save
end


Then /^I should see the site homepage$/ do
  page.should have_selector("body#site_home")
end

Then /^I should see the messageboard called "([^"]*)"$/ do |messageboard|
  page.should have_selector(".messageboard header h2", :text => messageboard)
end

Then /^I should see messageboards "([^"]*)" and "([^"]*)"$/ do |messageboard1, messageboard2|
  step %{I should see the messageboard called "#{messageboard1}"}
  step  %{I should see the messageboard called "#{messageboard2}"}
end

Given /^a custom cname site exists called "([^"]*)"$/ do |subdomain|
  random_subdomain = (0...4).map{65.+(rand(25)).chr}.join.downcase
  @site = Site.where("cached_domain = ? OR  subdomain = ?", subdomain, subdomain).first
  @site = Factory(:site, :cname_alias => subdomain, :subdomain => random_subdomain) if @site.nil?
end

Given /^"([^"]*)" has two messageboards named "([^"]*)" and "([^"]*)"$/ do |subdomain, messageboard1, messageboard2|
  @site = Site.where("cached_domain = ? OR  subdomain = ?", subdomain, subdomain).first
  @site.messageboards << Factory(:messageboard, :name => messageboard1, :title => messageboard1, :topics => [Factory(:topic)])
  @site.messageboards << Factory(:messageboard, :name => messageboard2, :title => messageboard2, :topics => [Factory(:topic)])
  @site.save
end

Then /^I should see the login form$/ do
  page.should have_selector('form#user_new')
end

Then /^I should not see the login form$/ do
  page.should_not have_selector('form#user_new')
end

Given /^"([^"]*)" is a "([^"]*)" site$/ do |domain, permission|
  @site = Site.where("cached_domain = ?", domain).first
  @site.permission = permission
  @site.save unless @site.nil?
end
