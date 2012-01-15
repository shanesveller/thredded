Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in

 Background: Default site
   Given the default "public" website domain is "example.com"

   Scenario: User is not signed up
    When I go to the sign in page
     And I sign in as "fake@person.com/password"
    Then I should see "Invalid email or password."
     And I should see "Login"

   Scenario: User enters wrong password
   Given I am signed up and confirmed as "confirmed@person.com/password"
    When I go to the sign in page
     And I sign in as "email@person.com/wrongpassword"
    Then I should see "Invalid email or password."
     And I should see "Login"

   Scenario: User signs in successfully
   Given I am signed up and confirmed as "email@person.com/password"
    When I go to the sign in page
     And I sign in as "email@person.com/password"
    Then I should see "Signed in"
