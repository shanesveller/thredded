# All following steps thanks to the guys at Thoughtbot, and the Clearance gem

# General
Then /^I should see error messages$/ do
  step %{I should see "errors prohibited"}
end

Then /^I should see an error message$/ do
  step %{I should see "error prohibited"}
end

Then /^I debug$/ do
  debugger
end

# Database

Given /^I signed up with "(.*)\/(.*)"$/ do |email, password|
  user = Factory :user,
    :email                 => email,
    :password              => password,
    :password_confirmation => password
end 

Given /^I am signed up and confirmed as "(.*)\/(.*)"$/ do |email, password|
  user = Factory :user,
    :name                  => email.split('@').first,
    :email                 => email,
    :password              => password,
    :password_confirmation => password
end

# Session

Then /^I should be signed in$/ do
  step %{I should see "Logout"} 
end

Then /^I should be signed out$/ do
  step %{I should see "Login"} 
end

Given /^I have signed in with "(.*)\/(.*)"$/ do |email, password|
  step %{I am signed up and confirmed as "#{email}/#{password}"}
  step %{I sign in as "#{email}/#{password}"}
end

Given /^I am signed in as "(.*)"$/ do |username|
  step %{I have signed in with "#{username}@email.com/mypassword"}
end

# Emails

Then /^a confirmation message should be sent to "(.*)"$/ do |email|
  user = User.find(:first, :conditions => {:email => email})
  assert !user.confirmation_token.blank?
  assert !ActionMailer::Base.deliveries.empty?
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [user.email] &&
    email.subject =~ /confirm/i &&
    email.body =~ /#{user.confirmation_token}/
  end
  assert result
end

When /^I follow the confirmation link sent to "(.*)"$/ do |email|
  user = User.find(:first, :conditions => {:email => email})
  visit new_user_confirmation_path(:user_id => user,
                                   :token   => user.confirmation_token)
end

Then /^a password reset message should be sent to "(.*)"$/ do |email|
  user = User.find(:first, :conditions => {:email => email})
  assert !user.confirmation_token.blank?
  assert !ActionMailer::Base.deliveries.empty?
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [user.email] &&
    email.subject =~ /password/i &&
    email.body =~ /#{user.confirmation_token}/
  end
  assert result
end

When /^I follow the password reset link sent to "(.*)"$/ do |email|
  user = User.find(:first, :conditions => {:email => email})
  visit edit_user_password_path(:user_id => user,
                                :token   => user.confirmation_token)
end

When /^I try to change the password of "(.*)" without token$/ do |email|
  user = User.find(:first, :conditions => {:email => email})
  visit edit_user_password_path(:user_id => user)
end

Then /^I should be forbidden$/ do
  assert_response :forbidden
end

# Actions

When /^I sign in as "(.*)\/(.*)"$/ do |email, password|
  step %{I go to the sign in page}
  step %{I fill in "Email" with "#{email}"}
  step %{I fill in "Password" with "#{password}"}
  step %{I press "Sign in"}
  @current_user = User.find_by_email(email)
end

When /^I sign out$/ do
  visit '/users/sign_out'
end

When /^I request password reset link to be sent to "(.*)"$/ do |email|
  step %{I go to the password reset request page}
  step %{I fill in "Email address" with "#{email}"}
  step %{I press "Reset password"}
end

When /^I update my password with "(.*)\/(.*)"$/ do |password, confirmation|
  step %{I fill in "Choose password" with "#{password}"}
  step %{I fill in "Confirm password" with "#{confirmation}"}
  step %{I press "Save this password"}
end

When /^I return next time$/ do
  step %{session is cleared}
  step %{I go to the homepage}
end
