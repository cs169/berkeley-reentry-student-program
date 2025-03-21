Feature: Canvas Login
  As a user
  I want to login with my Canvas account
  So that I can access the application

  Scenario: Successful login with Canvas
    Given I am on the landing page
    When I click "Login with Canvas"
    Then I should be redirected to Canvas for authentication
    And I should be successfully logged in
    And I should see "Successfully signed in with Canvas!"

  Scenario: Failed Canvas login
    Given I am on the landing page
    When I click "Login with Canvas"
    And the Canvas authentication fails
    Then I should see "Authentication failed"
    And I should be on the home page
