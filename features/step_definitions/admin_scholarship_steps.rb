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

# Use path helper and check title/header
Then("I should be on the manage scholarships page") do
  expect(page).to have_current_path(manage_scholarships_path)
  expect(page).to have_css("h1", text: "Manage Scholarships")
end

# Use path helper and check title/header
Then("I should be on the new scholarship page") do
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
  # Example helper call:
  # fill_in_rich_text_area(field, with: value)
  # Or direct Capybara interaction:
  find("label", text: field)
  find(".trix-content[aria-labelledby='#{field}_label']").set(value) # Adjust selector if needed
  # Placeholder: You need to implement the actual filling logic
  # based on how your rich text editor is set up.
  # This is a basic example for Trix.
  find(:xpath, "//label[contains(text(), '#{field}')]/following-sibling::input[@type='hidden'] | //label[contains(text(), '#{field}')]/..//div[contains(@class, 'trix-content')]").set(value)
  # The above XPath tries to find the hidden input associated with the label OR the trix-content div.
  # You might need to adjust the selector based on your exact HTML structure.
  puts "Warning: Placeholder step used for 'fill in rich text area \"#{field}\"'. Implement actual logic."
end

# Updated CSV verification step
Then("I should receive a CSV file") do
  expect(page.response_headers["Content-Type"]).to include("text/csv")
  # Check for a reasonable filename, e.g., scholarships.csv
  expect(page.response_headers["Content-Disposition"]).to match(/attachment; filename=".*scholarships.*\.csv"/i)
end

# Step to handle login - might belong in a more general authentication steps file
Given("I logged in as an {string}") do |role|
  # This is a placeholder. Replace with your actual login logic.
  # You might need to create a user, visit the login page, fill credentials, and submit.
  # Example using FactoryBot and Capybara:
  # user = FactoryBot.create(:user, role: role.downcase.to_sym) # Assuming role maps to a user attribute/factory trait
  # visit login_path
  # fill_in "Email", with: user.email
  # fill_in "Password", with: user.password # Or a default password if using FactoryBot sequence
  # click_button "Log in"
  # expect(page).to have_content("Signed in successfully") # Or similar confirmation
  puts "Warning: Placeholder step used for 'Given I logged in as an \"#{role}\"'. Implement actual login logic."
  # For testing purposes, you might bypass UI login if you have helper methods:
  # login_as(user)
end

# Generic step to click a link (add back if removed)
When("I click link {string}") do |link_text|
  click_link(link_text)
end

# Note: Generic steps like "click_button", "fill_in", "should see"
# are assumed to be defined elsewhere (e.g., web_steps.rb).
