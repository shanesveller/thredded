Feature: Add a new thread
  In order to start a new thread
  A user
  Should submit new content and see it on the messageboard listing page

Background: Default site and messageboard
    Given the default "public" website domain is "example.com"
      And the default website has a messageboard named "thredded"
      And I am signed in as "Joel"
      And I am a member of "thredded"
      And "thredded" is "public"

  Scenario: The member adds a new public thread
     When I go to the add a new thread page for "thredded"
      And I enter a title "This is a new thread" with content "Content for this new thread will show up here"
      And I submit the form
      And I go to the most recently updated thread on "thredded"
     Then I should see "This is a new thread"
      And I should see "Content for this new thread will show up here"

  Scenario: The member adds several new threads
    Given I create the following new threads:
          | title       | content                     |
          | topic 1     | hello I'm first             |
          | topic 2     | I'll come next              |
          | topic 3     | I should be the very latest |
     When I go to the messageboard "thredded"
     Then the topic listing should look like the following:
          | Topic Title | Started | Updated | Posts |
          | topic 3     | Joel    | Joel    | 1     |
          | topic 2     | Joel    | Joel    | 1     |
          | topic 1     | Joel    | Joel    | 1     |

  Scenario: The user adds a private thread
    Given another member named "john" exists
      And "john" is a member of "thredded"
     When I go to the new private thread page for "thredded"
      And I enter a recipient named "john", a title "sup john" and content "This is a private thread"
      And I submit the form
      And I go to the most recently updated thread on "thredded"
     Then I should see "Joel and John"
      And I should see "sup john"
      And I should see "This is a private thread"

  Scenario: A user cannot see a private thread
    Given a private thread exists between "Sal" and "John" titled "sal and john only please"
     When I go to the topic listing page
     Then I should not see "sal and john only please"

  Scenario: An admin can lock or pin a new thread
    Given I am a admin of "thredded"
     When I go to the add a new thread page for "ja"
     Then I should see "Locked"
      And I should see "Sticky"

  Scenario: A regular user cannot lock or pin a new thread
     When I go to the add a new thread page for "thredded"
     Then I should not see "Locked"
      And I should not see "Sticky"
