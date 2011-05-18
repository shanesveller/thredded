Feature: Edit an existing post
  In order to edit an existing post
  A user
  Should either be an admin or be the original poster

  Scenario: The member edits his own post
     Given I am signed in as "joel"
       And a messageboard named "thredded" that I, "joel", am a "member" of
       And the latest thread on "thredded" has several posts
       And the last post on the most recent thread is joels
      When I go to the most recently updated thread on "thredded"
      Then I should see an edit link for the last post

  Scenario: The member tries to edit someone elses thread
     Given I am signed in as "notjoel"
       And a messageboard named "thredded" that I, "notjoel", am a "member" of
       And the latest thread on "thredded" has several posts
       And the last post on the most recent thread is joels
       And the first post on the most recent thread is not joels
      When I go to the most recently updated thread on "thredded"
      Then I should not see an edit link for the last post
       And I should see an edit link for the first post

  Scenario: An admin edits someone elses thread
     Given I am signed in as "notjoel"
       And a messageboard named "thredded" that I, "notjoel", am an "admin" of
       And the latest thread on "thredded" has several posts
       And the last post on the most recent thread is not joels
      When I go to the most recently updated thread on "thredded"
      Then I should see an edit link for the last post
