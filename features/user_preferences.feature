Feature: User edits preferences
  In order to customize the experience
  A user
  Should be able to go to their profile and change their preferences

  Background: Default site and messageboard
    Given there is a messageboard named "thredded"
      And I am signed in as "joel"
      And I am a member of "thredded"
      And "thredded" is "public"
     When I go to my profile page
      And I select "thredded" as the board whose preferences I want to change

  Scenario: User changes at notification settings
     When I enable the '@ notification' preference
     Then I should see "Messageboard preferences updated"
      And I should be notified when someone mentions me
