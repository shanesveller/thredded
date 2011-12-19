Feature: Edit an existing post
  In order to edit an existing post
  A user
  Should either be an admin or be the original poster

Background: Default site and messageboard
    Given the default "public" website domain is "example.com"
      And the default website has a messageboard named "thredded"
      And I am signed in as "Joel"
      And I am a member of "thredded"
      And "thredded" is "public"

  Scenario: The member edits his own post
     Given the latest thread on "thredded" has several posts
       And the last post on the most recent thread is mine
      When I go to the most recently updated thread on "thredded"
      Then I should see an edit link for the last post

  Scenario: The member tries to edit someone elses thread
     Given the last post on the most recent thread is mine
       And the first post on the most recent thread is not mine
      When I go to the most recently updated thread on "thredded"
      Then I should not see an edit link for the last post
       And I should see an edit link for the first post

  Scenario: An admin edits someone elses thread
     Given I am an admin for "thredded"
       And the latest thread on "thredded" has several posts
       And the last post on the most recent thread is not mine
      When I go to the most recently updated thread on "thredded"
      Then I should see an edit link for the last post
