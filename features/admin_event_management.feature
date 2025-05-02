Feature: Admin Event Management
  As a logged-in admin
  I want to be able to add, edit, and delete events
  So that I can directly manipulate what events students see

  Background:
    Given I logged in as a "Admin"
    And I am on the admin dashboard
    And I click "Manage Events"
    Then I should land on the admin events page

  Scenario: Admin can view the admin events page
    Then I should see "Manage Events"
    And I should see "Title"
    And I should see "Description"
    And I should see "Date"
    And I should see "Time"
    And I should see "Location"
    And I should see "Flyer"
    And I should see "Actions"
    And I should see "Add New Event"
    And I should see "Back to Admin Dashboard"
    And I should see "Export"
  
  Scenario: Admin can create a new event successfully
    When I click "Add New Event"
    Then I should land on the new event page
    When I fill in "Title" with "Test Event"
    And I fill in "Date" with "2025-05-10"
    And I fill in "start-time" with "13:20"
    And I fill in "Location" with "Test location"
    And I fill in "Description" with "Test event description."
    And I click "Create Event"
    Then I should land on the admin events page
    And I should see "Event created successfully."
    And I should see "Test Event"
  
  Scenario: Admin cannot create an event with missing required fields
    When I click "Add New Event"
    Then I should land on the new event page
    When I fill in "Title" with "Test Event"
    And I leave "Date" empty
    And I leave "start-time" empty
    And I fill in "Location" with "Test location"
    And I fill in "Description" with "Test event description."
    And I click "Create Event"
    And I should see "Missing values. Failed to create event."
    And I should see "Date cannot be empty"
    And I should see "Start time cannot be empty"
  
  Scenario: Edit event form shows times without seconds
    Given the following event exists:
      | title        | start_time           | end_time             | date       | location    | description          |
      | Sample Talk  | 2025-05-01 14:30:45  | 2025-05-01 16:15:20  | 2025-05-01 | Room 101    | A test event session |
    When I visit the edit page for "Sample Talk"
    Then the start time field should show "14:30"
    And the end time field should show "16:15"
  
  Scenario: Admin tries to view an event show page
    Given the following event exists:
      | title        | start_time          | end_time            | date       | location | description   |
      | Sample Talk  | 2025-05-01 14:00:00 | 2025-05-01 15:00:00 | 2025-05-01 | Hall A   | Description.  |
    When I visit the show page for "Sample Talk"
    Then I should be redirected to the admin events page
  
  Scenario: Admin successfully updates an event
    Given the following event exists:
      | title        | start_time          | end_time            | date       | location | description   |
      | Test Event   | 2025-05-01 14:00:00 | 2025-05-01 15:00:00 | 2025-05-01 | Hall A   | Description.  |
    And I visit the admin events page
    When I click "Edit" for "Test Event"
    And I fill in "Title" with "Updated Event"
    And I click "Update Event"
    Then I should land on the admin events page
    And I should see "Event updated successfully."
    And I should see "Updated Event"

  Scenario: Admin fails to update an event due to a missing field
    Given the following event exists:
      | title        | start_time          | end_time            | date       | location | description   |
      | Test Event   | 2025-05-01 14:00:00 | 2025-05-01 15:00:00 | 2025-05-01 | Hall A   | Description.  |
    And I visit the admin events page
    When I click "Edit" for "Test Event"
    And I fill in "Title" with ""
    And I click "Update Event"
    Then I should stay on the edit event page
    And I should see "Failed to update event."
  
  Scenario: Admin deletes an existing event
    Given the following event exists:
      | title        | start_time          | end_time            | date       | location | description   |
      | Test Event   | 2025-05-01 14:00:00 | 2025-05-01 15:00:00 | 2025-05-01 | Hall A   | Description.  |
    And I visit the admin events page
    When I click "Delete" for "Test Event"
    Then I should be redirected to the admin events page
    And I should see "Event deleted successfully."
    And I should not see "Test Event"

  Scenario: Admin can export all events as CSV
    Given the following event exists":
      | title        | start_time          | end_time            | date       | location | description   |
      | Test Event   | 2025-05-01 14:00:00 | 2025-05-01 15:00:00 | 2025-05-01 | Hall A   | Description.  |
    And I visit the admin events page
    When I click link "Export"
    Then I should receive a CSV file named with "events"
    Then I should see "Test Event"
