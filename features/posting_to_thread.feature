Feature: Reply to a thread
  In order to reply to a thread
  A user
  Should submit new content and see it on that thread's page

  Background: Default site and messageboard
    Given there is a messageboard named "thredded"
      And I am signed in as "joel"
      And I am a member of "thredded"
      And "thredded" is "public"

  Scenario: The member adds a new reply
    Given a thread already exists on "thredded"
     When I go to the most recently updated thread on "thredded"
      And I select "bbcode" from "post_filter"
      And I submit some drivel like "oh my god this is the greatest, most [i]AMAZING[/i] thread of ALL TIME."
     Then I should see "oh my god this is the greatest, most AMAZING thread of ALL TIME."

  Scenario: The member adds a new reply with the textile filter
    Given a thread already exists on "thredded"
     When I go to the most recently updated thread on "thredded"
      And I select "textile" from "post_filter"
      And I submit some drivel like "oh my god this is the greatest, most __AMAZING__ thread of ALL TIME."
     Then I should see "oh my god this is the greatest, most AMAZING thread of ALL TIME."

  Scenario: The member has a default post filter preference
    Given a thread already exists on "thredded"
      And My post filter preference is "markdown"
     When I go to the most recently updated thread on "thredded"
     Then The filter at the reply form should default to "markdown"
