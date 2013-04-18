Feature: Tracking user behavior in a topic
  In order to track what they've already read
  A user
  Should see a difference between new and read topics

Background: Default site and messageboard
    Given there is a messageboard named "thredded"
      And I am signed in as "Joel"
      And I am a member of "thredded"
      And "thredded" is "public"

  Scenario: A member updates a topic I have previously read
    Given "3" threads already exist on "thredded"
      And I have read them all
     When someone responds to the oldest topic
      And I go to the topic listing page
     Then the first topic should be unread
      And the second topic should be read
