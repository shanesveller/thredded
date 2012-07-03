Feature: Receive emails
  In order to reply to a thread via email
  A user
  Should send an email to a messageboard to create or update a thread

Background: Default site and messageboard
    Given the default "public" website domain is "example.com"
      And the default website has a messageboard named "thredded"
      And I am signed in as "Joel"
      And I am a member of "thredded"
      And "thredded" is "public"

 Scenario: John sends an email
    Given another member named "john" exists
      And "john" is a member of "thredded"
     When "john@email.com" sends an email to "thredded@thredded.com" with subject "subject" and body "body"
      And I go to the most recently updated thread on "thredded"
     Then I should see "subject"
      And I should see "body"
