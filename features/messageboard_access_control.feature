Feature: Visiting a messageboard with various privileges
  In order to allow, or deny, users' access to a messageboard
  A user
  Should see the messageboard homepage or be notified of what the problem is

Background: Default site and messageboard
    Given there are two messageboards named "lol" and "kek"

  Scenario: The messageboard is private and "jimmy" is a member
    Given I am signed in as "jimmy"
      And I am a member of "lol"
      And "lol" is "private"
     When I go to the messageboard "lol"
     Then I should see a list of threads

  Scenario: The messageboard is private and "jon" is not a member
    Given I am signed in as "jon"
      And "lol" is "private"
      And I am not a member of "lol"
     When I go to the forum listing page
     Then I should not see "lol"
     When I go to the messageboard "lol"
     Then I should see "You are not authorized access to this messageboard."

  Scenario: The messageboard is private and I am anonymous
    Given I am an anonymous visitor
      And "lol" is "private"
     When I go to the messageboard "lol"
     Then I should see "You are not authorized access to this messageboard."
      And I should be signed out

  Scenario: The messageboard is for logged-in users and I am anonymous
    Given "lol" is "logged_in"
      And I am an anonymous visitor
     When I go to the messageboard "lol"
     Then I should see "You are not authorized access to this messageboard."
      And I should be signed out

  Scenario: The messageboard is for logged-in users and I am logged in
    Given "lol" is "logged_in"
      And I am signed in as "joel"
     When I go to the messageboard "lol"
     Then I should see a list of threads
      And I should see "Logout"

  Scenario: The messageboard is public
    Given "lol" is "public"
     When I go to the messageboard "lol"
     Then I should see a list of threads
      And I should see "Login"

  Scenario: The messageboard is public, I am signed in but I am not a member
    Given "lol" is "public"
      And I am signed in as "jeff"
      And I am not a member of "lol"
     When I go to the messageboard "lol"
     Then I should see a list of threads
      And I should see "Logout"

  Scenario: The messageboard is public and I am a member
    Given "lol" is "public"
      And I am signed in as "jeff"
      And I am a member of "lol"
     When I go to the messageboard "lol"
     Then I should see a list of threads
      And I should see "Logout"
