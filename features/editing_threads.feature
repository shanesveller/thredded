Feature: Edit an existing thread
  In order to edit an existing thread
  A user
  Should either be an admin or be the original poster

  Scenario: The member edits his own thread
     Given I am signed in as "joel"
       And a messageboard named "thredded" that I, "joel", am a "member" of
      When I go to the add a new thread page for "thredded"
       And I enter a title "This is a new thread" with content "Content for this new thread will show up here"
       And I submit the form
       # And I go to edit the latest thread
       And I go to the most recently updated thread on "thredded"
       And I click the edit subject link
      Then I should be able to edit this thread

  Scenario: The member tries to edit someone elses thread
     Given I am signed in as "john"
       And a messageboard named "thredded" that I, "john", am a "member" of
       And a new thread by "sal" named "hello friends" exists on "thredded"
      When I go to edit the latest thread
      Then I should not be able to edit this thread

  Scenario: An admin edits someone elses thread
     Given I am signed in as "john"
       And a messageboard named "thredded" that I, "john", am an "admin" of
       And a new thread by "sal" named "sup dudes" exists on "thredded"
      When I go to edit the latest thread
      Then I should be able to edit this thread
