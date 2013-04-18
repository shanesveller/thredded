Feature: Add a new thread
  In order to start a new thread
  A user
  Should submit new content and see it on the messageboard listing page

Background: Default site and messageboard
    Given there is a messageboard named "thredded"
      And I am signed in as "Joel"
      And I am a member of "thredded"
      And "thredded" is "public"

  Scenario: The member adds a new public thread
     When I go to the new thread page for "thredded"
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
          | Topic Title | Posts | Started | Updated |
          | topic 3     | 1     | Joel    | Joel    |
          | topic 2     | 1     | Joel    | Joel    |
          | topic 1     | 1     | Joel    | Joel    |

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
      And "john@email.com" should receive an email
      And "joel@email.com" should receive no emails

  Scenario: A user cannot see a private thread
    Given a private thread exists between "Sal" and "John" titled "sal and john only please"
     When I go to the topic listing page
     Then I should not see "sal and john only please"

  Scenario: An admin can lock or pin a new thread
    Given I am a admin of "thredded"
     When I go to the new thread page for "thredded"
     Then I should see "Locked"
      And I should see "Sticky"

  Scenario: A regular user cannot lock or pin a new thread
     When I go to the new thread page for "thredded"
     Then I should not see "Locked"
      And I should not see "Sticky"

  Scenario: Anonymous user cannot post to a public messageboard where posting is for logged-in users
    Given "thredded" posting permissions are constrained to those that are "logged_in"
      And I create the following new threads:
          | title       | content         |
          | topic 1     | hello I'm first |
     When I sign out
      And I go to the topic listing page
     Then I should not see "create a new topic"
      And I go to the new thread page for "thredded"
     Then I should see "Sorry, you are not authorized to post on this messageboard."
      And I go to the most recently updated thread on "thredded"
     Then I should not see the post reply form
