Feature: Edit an existing thread
  In order to edit an existing thread
  A user
  Should either be an admin or be the original poster

Background: Default site and messageboard
    Given the default "public" website domain is "example.com"
      And the default website has a messageboard named "thredded"
      And I am signed in as "Joel"
      And I am a member of "thredded"
      And "thredded" is "public"

  Scenario: The member edits his own thread
      When I go to the new thread page for "thredded"
       And I enter a title "This is a new thread" with content "Content for this new thread will show up here"
       And I submit the form
       And I go to the most recently updated thread on "thredded"
       And I click the edit subject link
      Then I should not see the content field
       And I change the title to "This is an old thread"
       And I click the edit topic button
      Then I should see "This is an old thread"

  Scenario: The member tries to edit someone elses thread
     Given a new thread by "sal" named "hello friends" exists on "thredded"
      When I go to edit the latest thread
      Then I should not be able to edit this thread

  Scenario: An admin edits someone elses thread
     Given I am an admin for "thredded"
       And a new thread by "sal" named "sup dudes" exists on "thredded"
      When I go to edit the latest thread
      Then I should be able to edit this thread
