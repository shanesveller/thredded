Feature: Visiting a messageboard with various privileges 
  In order to allow, or deny, users' access to a messageboard
  A user
  Should see the messageboard homepage or be redirected back to the login page

  Scenario: The messageboard is private and I am a member
#   Given a private messageboard exists named "thredded"
#     And I have signed in with "threddedmember@a.com/password"
    Given I am logged in and visiting a private messageboard
      And I am a member of the messageboard
    When I go to the messageboard topic listing
    Then I should see a list of threads

  Scenario: The messageboard is private and I am not a member
    Given I am logged in and visiting a private messageboard
      And I am a member of the messageboard
    When I go to the messageboard topic listing
    Then I should see "You are not a member of this messageboard. You need to be invited to participate."

#  Scenario: The messageboard is 
