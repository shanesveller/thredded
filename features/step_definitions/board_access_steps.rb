Given /^I am logged in and visiting a "(.*)" messageboard$/ do |security|
  Given %{a "#{security}" messageboard exists named "thredded"}
  And %{I am signed up and confirmed as "user@domain.com/omglol"}
  And %{I sign in as "user@domain.com/omglol"}
end

Given /^I am a member of the messageboard$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am not a member of the messageboard$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am an anonymous visitor of the messageboard$/ do
  pending # express the regexp above with the code you wish you had
end