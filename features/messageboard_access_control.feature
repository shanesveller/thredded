Feature: Visiting a messageboard with various privileges 
  In order to allow, or deny, users' access to a messageboard
  A user
  Should see the messageboard homepage or be notified of what the problem is

  Scenario: The messageboard is private and "Jimmy" is a member
    Given I am signed in as "Jimmy"
      And I go to a "private" messageboard
      And I am a member of the messageboard
     When I go to the topic listing page
     Then I should see a list of threads

  Scenario: The messageboard is private and "Jon" is not a member
    Given I am signed in as "Jon" 
      And I go to a "private" messageboard
      And I am not a member of the messageboard
     When I go to the topic listing page
     Then I should see "You are not authorized to access this page."

  Scenario: The messageboard is private and I am anonymous
    Given I am an anonymous visitor of the messageboard
      And I go to a "private" messageboard
     When I go to the topic listing page
     Then I should see "You are not authorized to access this page."

  Scenario: The messageboard is public and I am not a member
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