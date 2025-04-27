Feature: Admin Scholarship Management
  As an admin
  I want to manage scholarships
  So that I can keep the scholarship information up-to-date

  Background: Logged in as admin and on the manage scholarships page
    Given I logged in as a "Admin"
    And I am on the admin dashboard
    And I click "Manage Scholarships"
    Then I should land on the admin manage scholarships page

  Scenario: Admin can view the manage scholarships page
    Then I should see "Manage Scholarships"
    And I should see "Name"
    And I should see "Description"
    And I should see "Status"
    And I should see "Application URL"
    And I should see "Actions"
    And I should see "Add New Scholarship"
    And I should see "Export"

  @javascript
  Scenario: Admin can add a new scholarship
    When I click "Add New Scholarship"
    Then I should land on the new scholarship page
    When I fill in "Name" with "Test Scholarship"
    And I fill in rich text area "Description" with "This is a test scholarship description."
    And I fill in "Status text" with "Active"
    And I fill in the Application URL field with "https://example.com/apply"
    And I click "Create Scholarship"
    Then I should land on the admin manage scholarships page
    And I should see "Scholarship was successfully created."
    And I should see "Test Scholarship"

  @javascript
  Scenario: Admin can edit an existing scholarship
    # Assuming a scholarship named "Existing Scholarship" already exists
    Given the following scholarships exist:
      | name                 | description            | status text | application_url        |
      | Existing Scholarship | Original description   | Active      | https://example.com/old |
    And I am on the manage scholarships page
    When I click "Edit" for "Existing Scholarship"
    Then I should land on the edit scholarship page for "Existing Scholarship"
    When I fill in "Name" with "Updated Scholarship Name"
    And I click "Update Scholarship"
    Then I should be on the manage scholarships page
    And I should see "Scholarship was successfully updated."
    And I should see "Updated Scholarship Name"
    And I should not see "Existing Scholarship"

  @javascript
  Scenario: Admin can delete an existing scholarship
    # Assuming a scholarship named "Scholarship To Delete" already exists
    Given the following scholarships exist:
      | name                  | description          | status text | application_url        |
      | Scholarship To Delete | Delete this one    | Active      | https://example.com/del |
    And I am on the manage scholarships page
    When I click "Delete" for "Scholarship To Delete"
    Then I should land on the admin manage scholarships page
    And I should see "Scholarship was successfully destroyed."
    And I should not see "Scholarship To Delete"

  Scenario: Admin can export scholarships
    When I click link "Export"
    Then I should receive a CSV file 