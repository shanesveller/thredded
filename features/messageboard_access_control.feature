Feature: Visiting a messageboard with various privileges 
  In order to allow, or deny, users' access to a messageboard
  A user
  Should see the messageboard homepage or be notified of what the problem is

Background: Default site and messageboard
    Given the default "public" website domain is "example.com"
      And a custom cname site exists called "mi.com"
      And "mi.com" has two messageboards named "lol" and "kek"

  Scenario: The messageboard is private and "Jimmy" is a member
    Given I am signed in as "Jimmy"
      And I am a member of "lol"
      And "lol" is "private"
     When I go to the messageboard "lol"
     Then I should see a list of threads

  Scenario: The messageboard is private and "Jon" is not a member
    Given I am signed in as "Jon" 
      And "lol" is "private"
      And I am not a member of "lol"
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
      And I am signed in as "Joel" 
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
      And I am signed in as "Jeff" 
      And I am not a member of "lol"
     When I go to the messageboard "lol"
     Then I should see a list of threads
      And I should see "Logout"

  Scenario: The messageboard is public and I am a member
    Given "lol" is "public"
      And I am signed in as "Jeff" 
      And I am a member of "lol"
     When I go to the messageboard "lol"
     Then I should see a list of threads
      And I should see "Logout"
