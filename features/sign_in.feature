Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in

   Scenario: User is not signed up
   Given the default "public" website domain is "example.com"
    When I go to the sign in page
     And I sign in as "fake@person.com/password"
    Then I should see "Invalid email or password."
     And I should be signed out

   Scenario: User enters wrong password
   Given the default "public" website domain is "example.com"
     And I am signed up and confirmed as "confirmed@person.com/password"
    When I go to the sign in page
     And I sign in as "email@person.com/wrongpassword"
    Then I should see "Invalid email or password."
     And I should be signed out

#   Scenario: User signs in successfully
#      Given I am signed up and confirmed as "email@person.com/password"
#      When I go to the sign in page
#      And I sign in as "email@person.com/password"
#      Then I should see "Signed in"
#      And I should be signed in
#      When I return next time
#      Then I should be signed in
