Feature: Add a new thread
  In order to start a new thread
  A user
  Should submit new content and see it on the messageboard listing page

  Scenario: The member adds a new public thread
     Given a messageboard named "thredded" that I, "joel", am a "member" of
      When I go to the add a new thread page for "thredded"
       And I enter a title "This is a new thread" with content "Content for this new thread will show up here"
       And I submit the form
       And I go to the most recently updated thread on "thredded"
      Then I should see "This is a new thread"
       And I should see "Content for this new thread will show up here"

  Scenario: The member adds several new threads
     Given a messageboard named "thredded" that I, "joel", am a "member" of
       And I create the following new topics:
           | title       | content                     |
           | topic 1     | hello I'm first             |
           | topic 2     | I'll come next              |
           | topic 3     | I should be the very latest |
       And I go to the topic listing page
      Then the topic listing should look like the following:
           | Topic Title | Started | Updated | Posts |
           | topic 3     | joel    | joel    | 1     |
           | topic 2     | joel    | joel    | 1     |
           | topic 1     | joel    | joel    | 1     |

  Scenario: The member adds new threads, and locks one
     Given a messageboard named "thredded" that I, "joel", am a member of
       And I create the following new topics:
           | title       | content                     |
           | topic 1     | hello I'm first             |
           | topic 2     | I'll come next              |
           | topic 3     | I should be the very latest |
       And "topic 1" is locked
       And I go to the topic listing page
      Then the topic listing should look like the following:
           | Topic Title | Started | Updated | Posts |
           | topic 1     | joel    | joel    | 1     |
           | topic 3     | joel    | joel    | 1     |
           | topic 2     | joel    | joel    | 1     |

  Scenario: Members can not lock a thread or make it sticky
     Given a messageboard named "thredded" that I, "matt", am a member of
      When I go to the add a new thread page for "thredded"
      Then I should not see "thread locked"
       And I should not see "sticky"

  Scenario: Admins can lock a thread or make it sticky
     Given a messageboard named "thredded" that I, "joel", am an admin of
      When I go to the add a new thread page for "thredded"
      Then I should see "thread locked"
       And I should see "sticky"

  Scenario: The user adds a private thread
     Given I am signed in as "joel"
       And a messageboard named "thredded" that I, "joel", am a "member" of
       And another member named "john" exists
      When I go to the add a new thread page for "thredded"
       And I enter a recipient named "john", a title "sup john" and content "This is a private thread"
       And I submit the form
       And I go to the most recently updated thread on "thredded"
      Then I should see "Joel and John"
       And I should see "sup john"
       And I should see "This is a private thread"

  Scenario: A user cannot see a private thread
     Given a messageboard named "ja" that I, "joel", am a "member" of
       And a private thread exists between "Sal" and "John" titled "sal and john only please!"
      When I go to the topic listing page
      Then I should not see "sal and john only please!"

  Scenario: An admin can lock or pin a new thread
     Given I am signed in as "joel"
       And a messageboard named "ja" that I, "joel", am an "admin" of
      When I go to the add a new thread page for "ja"
      Then I should see "Locked"
       And I should see "Sticky"

  Scenario: A regular user cannot lock or pin a new thread
     Given a messageboard named "ja" that I, "jack", am a "member" of
      When I go to the add a new thread page for "ja"
      Then I should not see "Locked"
       And I should not see "Sticky"
