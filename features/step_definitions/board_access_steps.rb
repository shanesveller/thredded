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

Given /^I am not a member of the messageboard$/ do
  user = User.last
  user.roles.delete_all
end

Given /^I am an anonymous visitor of the messageboard$/ do
  user = User.new
end
