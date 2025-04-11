Feature: Canvas Authentication
  As a user
  I want to be able to login with my Canvas account
  So that I can access the application

  Scenario: Failed Canvas login
    Given I am on the landing page
    When I click the button "Login with Canvas"
    And I deny the authorization
    Then I should be on the landing page
    And I should see "Authentication failed. Please try again."