Feature: Locked and Sticky threads
  As an admin
  I want to assign special attributes to a thread
  So that locked threads can no longer posted on
  And so that important threads can be "stuck" to the top of the topics listing

Background: Default site and messageboard
    Given the default "public" website domain is "example.com"
      And the default website has a messageboard named "thredded"
      And I am signed in as "Joel"
      And I am a member of "thredded"
      And "thredded" is "public"

  Scenario: A thread is locked
    Given a new thread by "sal" named "Controversial topic" exists on "thredded"
      And the thread is locked
     When I go to the latest thread
     Then I should not see the reply form

  Scenario: A thread is stuck
    Given a new thread by "john" named "READ FIRST" exists on "thredded"
      And a new thread by "fred" named "other stuff" exists on "thredded"
      And a new thread by "george" named "herp derp" exists on "thredded"
      And the thread "READ FIRST" is sticky
     When I go to the the topic listing page
     Then the top-most thread should be "READ FIRST"
