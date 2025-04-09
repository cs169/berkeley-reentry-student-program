Feature: Canvas Authentication
  As a user
  I want to be able to login with my Canvas account
  So that I can access the application

  Scenario: Successful Canvas login
    Given I am on the landing page
    When I click the button "Login with Canvas"
    Then I should be redirected to Canvas for authentication
    When I authorize the application
    Then I should be on the landing page
    And I should see "Success! You've been logged-in!"

  Scenario: Failed Canvas login
    Given I am on the landing page
    When I click the button "Login with Canvas"
    And I deny the authorization
    Then I should be on the landing page
    And I should see "Authentication failed. Please try again."

  Scenario: Missing Canvas configuration
    Given the Canvas configuration is missing
    When I click the button "Login with Canvas"
    Then I should be on the landing page
    And I should see "Canvas configuration is missing"