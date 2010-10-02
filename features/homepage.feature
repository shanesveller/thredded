Feature: Visiting the homepage
  In order to view the correct content on the homepage    
  A user
  Should see content commensurate with the website's settings

    Scenario: The site is public
      When I go to the homepage for "default"
      Then I should see "default home"
      And I should be signed out

    Scenario: The site is private 
      When I go to the homepage for "default"
      Then I should see "This messageboard is private. Please log in."
      And I should be signed out

    Scenario: The site is public for those that are signed in
      When I go to the homepage for "default"
      Then I should see "This messageboard is public, but you must be logged in to see it."
      And I should be signed out
