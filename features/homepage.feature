Feature: Visiting the homepage
  In order to view the correct content on the homepage    
  A user
  Should see content commensurate with the website's settings

  Scenario: The messageboard is not the homepage
    Given a public messageboard exists named "thredded"
      And I set the default messageboard home to "home"
      And I set the default messageboard to "thredded"
    When I go to the homepage
    Then I should see the main site homepage

  Scenario: The default messageboard is public
    Given a public messageboard exists named "thredded"
      And I set the default messageboard home to "topics"
      And I set the default messageboard to "thredded"
    When I go to the homepage
    Then I should see "thredded threads"
    And I should be signed out

  Scenario: The default messageboard is private 
    Given a private messageboard exists named "thredded"
      And I set the default messageboard home to "topics"
      And I set the default messageboard to "thredded"
    When I go to the homepage
    Then I should see "This messageboard is private. Please log in."
    And I should be signed out

  Scenario: The default messageboard locks out those that are logged in
    Given a logged_in messageboard exists named "thredded"
      And I set the default messageboard home to "topics"
      And I set the default messageboard to "thredded"
    When I go to the homepage
    Then I should see "This messageboard is public, but you must be logged in to see it."
    And I should be signed out
 
  Scenario: The default messageboard allows those that are logged in
    Given a logged_in messageboard exists named "thredded"
      And I set the default messageboard home to "topics"
      And I set the default messageboard to "thredded"
      And I have signed in with "confirmed@person.com/password"
    When I go to the homepage
    Then I should see "thredded threads"
    And I should be signed in
