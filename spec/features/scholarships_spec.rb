# frozen_string_literal: true

# spec/features/scholarships_spec.rb

require "rails_helper"

STUDENT_CREDENTIALS = {
  "provider" => "google_oauth2",
  "uid" => "1000000000",
  "info" => {
    "name" => "Google Test Developer",
    "email" => "google_student@berkeley.edu",
    "first_name" => "Google",
    "last_name" => "Test Developer"
  },
  "credentials" => {
    "token" => "credentials_token_1234567",
    "refresh_token" => "credentials_refresh_token_45678"
  }
}

RSpec.feature "Scholarships", type: :feature do
  let(:student) { create(:student) }
  let!(:published_scholarship) { create(:scholarship, name: "Published Grant", description: "For continuing students", status_text: "published", application_url: "http://apply.here/published") }
  let!(:draft_scholarship) { create(:scholarship, name: "Draft Award", description: "Internal draft", status_text: "draft", application_url: "http://apply.here/draft") }
  let!(:unpublished_scholarship) { create(:scholarship, name: "Old Scholarship", description: "Not active anymore", status_text: "unpublished", application_url: "http://apply.here/old") }

  before do
    OmniAuth.config.add_mock(
        :google_oauth2,
        STUDENT_CREDENTIALS
      )
    @student = FactoryBot.create :student, email: "google_student@berkeley.edu"
    page.set_rack_session(current_user_id: student.id)
  end

  scenario "user can view scholsarships index page" do
    visit root_path
    click_button "Login with Google"
    expect(page).to have_link("Re-entry Scholarships", href: scholarships_path)
    click_link "Re-entry Scholarships"
    expect(page).to have_content("Awards")
    expect(current_path).to eq(scholarships_path)
  end

  scenario "Student views the list of scholarships" do
    visit scholarships_path

    expect(page).to have_content(published_scholarship.name)
    expect(page).to have_content(published_scholarship.description)
    expect(page).to have_link("Apply Here", href: published_scholarship.application_url)

    expect(page).not_to have_content(draft_scholarship.name)
    expect(page).not_to have_content(unpublished_scholarship.name)
    expect(page).not_to have_link("Apply Here", href: draft_scholarship.application_url)
    expect(page).not_to have_link("Apply Here", href: unpublished_scholarship.application_url)

    expect(page).to have_content("Available Scholarships")
  end

  scenario "Student sees a message when no scholarships are available" do
    published_scholarship.update(status_text: "archived")

    visit scholarships_path

    expect(page).to have_content("There are currently no scholarships available.")
    expect(page).not_to have_content(published_scholarship.name)
    expect(page).not_to have_content(draft_scholarship.name)
    expect(page).not_to have_content(unpublished_scholarship.name)
  end
end
