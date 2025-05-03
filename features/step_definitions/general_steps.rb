# frozen_string_literal: true

When(/^(?:|I )click "([^"]*)"$/) do |bol|
  click_link_or_button(bol)
end

Then(/^(?:|I )should got "([^"]*)"$/) do |text|
  expect(page).to have_selector(:link_or_button, text)
end

Then(/^(?:|I )should not got "([^"]*)"$/) do |text|
  expect(page).not_to have_selector(:link_or_button, text)
end

Then(/^I leave "(.*?)" empty$/) do |field|
  fill_in field, with: ""
end

Then("I should receive a CSV file named with {string}") do |prefix|
  disposition = page.response_headers["Content-Disposition"]
  expect(disposition).to include("attachment;")
  expect(disposition).to match(/filename="#{prefix}-\d{4}-\d{2}-\d{2}\.csv"/)
end
