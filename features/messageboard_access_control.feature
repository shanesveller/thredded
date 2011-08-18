Feature: Visiting a messageboard with various privileges 
  In order to allow, or deny, users' access to a messageboard
  A user
  Should see the messageboard homepage or be notified of what the problem is

  Scenario: The messageboard is private and "Jimmy" is a member
    Given the default "public" website domain is "example.com"
      And the default website has a messageboard named "lol"
      And I am signed in as "Jimmy"
      And I am a member of "lol"
      And I go to a "private" messageboard
     When I go to the topic listing page
     Then I should see a list of threads

  Scenario: The messageboard is private and "Jon" is not a member
    Given I am signed in as "Jon" 
      And I am not a member of "lol"
      And I go to a "private" messageboard
     When I go to the topic listing page
     Then I should see "You are not authorized to access this page."

  Scenario: The messageboard is private and I am anonymous
    Given I am an anonymous visitor of the messageboard
      And I go to a "private" messageboard
     When I go to the topic listing page
     Then I should see "You are not authorized to access this page."

  Scenario: The messageboard is for those that are logged in and I am anonymous
    Given a "logged_in" messageboard exists named "thredded"
      And I am an anonymous visitor of the messageboard
      And I set the default messageboard home to "topics"
      And I set the default messageboard to "thredded"
     When I go to the homepage
     Then I should see "This messageboard is public, but you must be logged in to see it."
      And I should be signed out

  Scenario: The messageboard is for those that are logged in and I am logged in
    Given a "logged_in" messageboard exists named "thredded"
      And I have signed in with "confirmed@person.com/password"
      And I set the default messageboard home to "topics"
      And I set the default messageboard to "thredded"
     When I go to the homepage
     Then I should see a list of threads
      And I should be signed in

  Scenario: The messageboard is public
    Given a "public" messageboard exists named "thredded"
     When I go to the homepage
     Then I should see a list of threads
      And I should be signed out

  Scenario: The messageboard is public, I am signed in but I am not a member
    Given I am signed in as "Jeff" 
      And I go to a "public" messageboard
      And I am not a member of the messageboard
     When I go to the topic listing page
     Then I should see a list of threads

  Scenario: The messageboard is public and I am a member
    Given I am signed in as "Jeff" 
      And I go to a "public" messageboard
      And I am a member of the messageboard
     When I go to the topic listing page
     Then I should see a list of threads
