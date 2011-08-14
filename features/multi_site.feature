Feature: Multiple websites for a single installation
  In order to serve multiple domains
  An install of thredded
  Should serve the appropriately scoped messageboards and threads

  Scenario: Default domain "example.com" has its own messageboards
    Given the default "public" website domain is "example.com"
      And the default website has two messageboards named "lol" and "kek"
      And I have signed in with "confirmed@person.com/password"
     When I visit "example.com"
     Then I should see messageboards "lol" and "kek"

  Scenario: Two sites use their own subdomains  
    Given the default "public" website domain is "example.com"
      And a subdomain site exists called "red.example.com"
      And a subdomain site exists called "blue.example.com"
      And "red.example.com" has two messageboards named "foo" and "bar"
      And "blue.example.com" has two messageboards named "baz" and "carl"
      And I have signed in with "confirmed@person.com/password"
     When I visit "red.example.com"
     Then I should see messageboards "foo" and "bar"
      And I visit "blue.example.com"
     Then I should see messageboards "baz" and "carl"

  Scenario: One subdomain site and one custom domain site
    Given the default "public" website domain is "example.com"
      And a subdomain site exists called "red.example.com"
      And a custom domain site exists called "www.forum.com"
      And "red.example.com" has two messageboards named "foo" and "bar"
      And "www.forum.com" has two messageboards named "baz" and "carl"
      And I have signed in with "confirmed@person.com/password"
     When I visit "red.example.com"
     Then I should see messageboards "foo" and "bar"
      And I visit "www.forum.com"
     Then I should see messageboards "baz" and "carl"

  # TODO: test login.  something is definitely wrong
  Scenario: Website is behind a login and I am signed in
    Given the default "logged_in" website domain is "example.org"
      And I am signed up and confirmed as "confirmed@person.com/password"
     When I go to the sign in page
      And I fill in "Email" with "confirmed@person.com"
      And I fill in "Password" with "password"
      And I press "Sign in"
     Then I should see "Signed in successfully."
      And I should not see the login form
  
  Scenario: Website is behind a login and I am not signed in
    Given the default "logged_in" website domain is "example.com"
     When I visit "example.com"
     Then I should see the login form
