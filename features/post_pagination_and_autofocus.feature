Feature: Paginating posts and re-focusing on last read
  In order to pick up where they left off
  A user
  Returns to a recently updated thread and focuses on the last post they read

Background: Default site and messageboard
    Given the default "public" website domain is "example.com"
      And the default website has a messageboard named "thredded"
      And I am signed in as "Joel"
      And I am a member of "thredded"
      And "thredded" is "public"
      And posts are paginated every 5 posts

  Scenario: The member visits and revisits the latest thread
    Given the latest thread on "thredded" has 6 posts
     When I go to the most recently updated thread on "thredded"
     Then the latest read post should be the first post
     When I go to the most recently updated thread on "thredded" again
     Then the latest read post should be the fifth post
     When I click to page 2 and view the latest post
      And 2 more people post on the latest thread
      And I go to the topic listing page
      And I go to the most recently updated thread on "thredded" again
     Then I should see page 2
      And I should see 3 posts
      And the latest read post should be the sixth post
