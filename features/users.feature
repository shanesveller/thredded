Feature: Viewing users' information
  In order to learn more about other users
  A user
  Should be able to view a user's profile or a list of other users

Background: Default site and messageboard
    Given the default "public" website domain is "example.com"
      And the default website has a messageboard named "thredded"
      And I am signed in as "Joel"
      And I am a member of "thredded"
      And "thredded" is "public"

  Scenario: User views another user's profile
    Given another member named "john" exists
    When I go to the user profile page for "john"
    Then I should see "john"

  Scenario: User visits a nonexistant user's profile
    When I go to a user profile that doesn't exist
    Then I should see "No user exists named dkjflsdfdf"

