# frozen_string_literal: true

Then("I should land on the admin events page") do
  expect(current_path).to eq admin_events_path
end

Then("I should land on the new event page") do
  expect(current_path).to eq new_admin_event_path
end

Then("I should land on the edit event page") do
  expect(current_path).to eq edit_admin_event_path
end

Then("I should stay on the edit event page") do
  expect(page).to have_current_path(current_path, ignore_query: true)
  expect(current_path).to match(%r{/admin/events/\d+})
end

Given("the following event exists:") do |table|
  table.hashes.each do |event_attrs|
    Event.create!(event_attrs)
  end
end

When("I visit the edit page for {string}") do |event_title|
  event = Event.find_by!(title: event_title)
  visit edit_admin_event_path(event)
end

When("I visit the admin events page") do
  visit admin_events_path
end

Then("the start time field should show {string}") do |expected_time|
  start_time_value = find_field("start-time").value
  expect(start_time_value).to include(expected_time)
end
  
Then("the end time field should show {string}") do |expected_time|
  end_time_value = find_field("end-time").value
  expect(end_time_value).to include(expected_time)
end

When("I visit the show page for {string}") do |event_name|
  event = Event.find_by!(title: event_name)
  visit admin_event_path(event)
end

Then("I should be redirected to the admin events page") do
  expect(page).to have_current_path(admin_events_path)
  expect(page).to have_content("Manage Events")
end
