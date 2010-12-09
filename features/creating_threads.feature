Feature: Add a new thread
  In order to start a new thread
  A user
  Should submit new content and see it on the messageboard listing page

  Scenario: The member adds a new public thread
#     Given a "public" messageboard exists named "thredded"
#       And I am a member of the messageboard
     Given a messageboard that I am a member of
      When I go to the add a new thread page
       And I enter a title "This is a new thread" with content "Content for this new thread will show up here"
       And I submit the form
       And I go to the most recently updated thread
      Then I should see "This is a new thread"
       And I should see "Content for this new thread will show up here"

  Scenario: The user adds a private thread
     Given a messageboard that I am a member of
       And another member named "John"
      When I go to the add a private thread page
       And I enter a recipient named "john", a title "Hello John" and content "This is a private thread"
       And I submit the form
       And I go to the most recently updated thread
      Then I should see "Joel and John"
       And I should see "Hello John"
       And I should see "This is a private thread"

  Scenario: A user cannot see a private thread
     Given a messageboard that I am a member of
       And a private thread exists between "Sal" and "John" titled "This is a private thread"
      When I go to the messageboard topic listing
      Then I should not see "This is a private thread"