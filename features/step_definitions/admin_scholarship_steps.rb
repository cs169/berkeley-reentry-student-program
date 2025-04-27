# frozen_string_literal: true

require "uri"
require "cgi"
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

# Assuming you have selector_for and path_to defined in support files
# And helper methods like accept_turbo_confirm and fill_in_rich_text_area

module WithinHelpers
  def with_scope(locator, &block)
    locator ? within(*selector_for(locator), &block) : yield
  end
end
World(WithinHelpers)

# Placeholder for navigating to the manage scholarships page
Then("I should land on the admin manage scholarships page") do
  expect(page).to have_current_path(manage_scholarships_path)
  expect(page).to have_css("h1", text: "Manage Scholarships")
end

# Use path helper and check title/header
Then("I should land on the new scholarship page") do
  expect(page).to have_current_path(new_scholarship_path)
  expect(page).to have_content("New Scholarship") # Adjust if title is different
end

# Updated Given step to use 'status text' and note rich text description
Given("the following scholarships exist:") do |scholarships_table|
  scholarships_table.hashes.each do |scholarship_data|
    # Note: Creating rich text content might require specific formatting
    # if your model expects Action Text attributes directly.
    # This assumes Scholarship.create handles the plain text correctly.
    Scholarship.create!(
      name: scholarship_data["name"],
      description: scholarship_data["description"],
      status_text: scholarship_data["status text"], # Use status_text from feature
      application_url: scholarship_data["application_url"]
    )
  end
end

# Refined step for clicking Edit/Delete in a table row
When(/^(?:|I )click "(Edit|Delete)" for "([^"]*)"$/) do |action, scholarship_name|
  # Find the row more robustly by finding the cell with the name, then the row
  row = find("td", text: scholarship_name).ancestor("tr")

  within(row) do
    if action == "Edit"
      click_link(action)
    elsif action == "Delete"
      # Assumes you have an accept_turbo_confirm helper for Turbo Stream confirmation dialogs
      # Define this helper in your features/support files.
      accept_turbo_confirm do
        click_button(action)
      end
    end
  end
end

# Use path helper and check title/header
Then(/^I should be on the edit scholarship page for "([^"]*)"$/) do |scholarship_name|
  scholarship = Scholarship.find_by!(name: scholarship_name)
  expect(page).to have_current_path(edit_scholarship_path(scholarship))
  expect(page).to have_content("Edit Scholarship") # Adjust if title is different
end

# Step definition for filling in rich text (Trix editor)
# Assumes you have a helper function like fill_in_rich_text_area
# defined in your features/support files.
When(/^(?:|I )fill in rich text area "([^"]*)" with "([^"]*)"$/) do |field, value|
  # Find the hidden input field associated with the rich text area.
  hidden_input_id = "scholarship_#{field.downcase.gsub(' ', '_')}_trix_input_scholarship"

  # Use execute_script to set the value of the hidden field directly
  # This is a workaround for potential issues with Capybara finding/filling the hidden Trix input
  page.execute_script("document.getElementById('#{hidden_input_id}').value = \"#{value}\";")

  # Remove the placeholder warning if this works
  # puts "Warning: Placeholder step used for 'fill in rich text area \"#{field}\"'. Implement actual logic."
end

# Specific step to fill in Application URL by ID
When("I fill in the Application URL field with {string}") do |value|
  fill_in 'scholarship_application_url', with: value
end

# Updated CSV verification step
Then("I should receive a CSV file") do
  expect(page.response_headers["Content-Type"]).to include("text/csv")
  # Check for a reasonable filename, e.g., scholarships.csv
  expect(page.response_headers["Content-Disposition"]).to match(/attachment; filename=".*scholarships.*\.csv"/i)
end

# Generic step to click a link (add back if removed)
When("I click link {string}") do |link_text|
  click_link(link_text)
end

# Note: Generic steps like "click_button", "fill_in", "should see"
# are assumed to be defined elsewhere (e.g., web_steps.rb).
