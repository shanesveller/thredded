When /^I enable the '@ notification' preference$/ do
  within '[data-section="preferences"]' do
    check "Notify me when I am @'ed"
    click_button 'Update Preferences'
  end
end

Then /^I should be notified when someone mentions me$/ do
  me = User.last
  create(:post, content: "hi @#{me.name}", messageboard: me.messageboards.first,
    topic: create(:topic, messageboard: me.messageboards.first))

  steps %Q{
    When "email@email.com" opens the email
    Then they should see "@#{me.name}" in the email body
    And they should see "mentioned you in" in the email body
  }
end

When /^I select "([^"]*)" as the board whose preferences I want to change$/ do |board|
  within '[data-section="preferences"]' do
    select board, from: 'Select Messageboard'
    click_button 'Submit'
  end
end
