Given /^I am logged in and visiting a "(.*)" messageboard$/ do |security|
  Given %{a "#{security}" messageboard exists named "thredded"}
  And %{I am signed up and confirmed as "user@domain.com/omglol"}
  And %{I sign in as "user@domain.com/omglol"}
end

Given /^I am a member of "(.*)"$/ do |name|
  user = User.last
  user.member_of Messageboard.find_by_name(name)
  user.reload
end

Given /^I am not a member of "(.*)"$/ do |name|
  user = User.last
  user.roles.delete_all
  user.reload
end

Given /^I am an anonymous visitor$/ do
  create(:user)
  user = User.new
end

Given /^I am an admin for "([^"]*)"$/ do |name|
  @current_user.admin_of Messageboard.find_by_name(name)
end
