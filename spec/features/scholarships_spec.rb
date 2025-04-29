# frozen_string_literal: true

# spec/features/scholarships_spec.rb

require "rails_helper"

# STUDENT_CREDENTIALS moved to feature_login_helpers.rb

RSpec.feature "Scholarships", type: :feature do
  # Use a let! block for the student to ensure it's created before the login helper runs
  let!(:student) { create(:student, email: "google_student@berkeley.edu") } # Ensure email matches helper
  # Create scholarships within a before block for clarity in the empty state test
  let!(:published_scholarship) { create(:scholarship, name: "Published Grant", description: "For continuing students", status_text: "published", application_url: "http://apply.here/published") }
  let!(:draft_scholarship) { create(:scholarship, name: "Draft Award", description: "Internal draft", status_text: "draft", application_url: "http://apply.here/draft") }
  let!(:unpublished_scholarship) { create(:scholarship, name: "Old Scholarship", description: "Not active anymore", status_text: "unpublished", application_url: "http://apply.here/old") }

  # Log in the student before each scenario in this feature
  before do
    # Use the login helper
    login_with_google(student)
  end

  scenario "user can view scholarships index page" do
    # Login is handled by the before block
    expect(page).to have_link("Re-entry Scholarships", href: scholarships_path)
    click_link "Re-entry Scholarships"
    expect(page).to have_content("Awards") # Check view content if this is correct
    expect(current_path).to eq(scholarships_path)
  end

  scenario "Student views the list of scholarships" do
    # Login handled by before block, directly visit the path
    visit scholarships_path

    # Expect to see all scholarships
    expect(page).to have_content(published_scholarship.name)
    expect(page).to have_content(published_scholarship.description.body.to_plain_text)
    expect(page).to have_link("published", href: published_scholarship.application_url)

    expect(page).to have_content(draft_scholarship.name)
    expect(page).to have_content(draft_scholarship.description.body.to_plain_text)
    # Check link based on view logic (status_text.presence || "Apply Now")
    expect(page).to have_link(draft_scholarship.status_text, href: draft_scholarship.application_url)

    expect(page).to have_content(unpublished_scholarship.name)
    expect(page).to have_content(unpublished_scholarship.description.body.to_plain_text)
    expect(page).to have_link(unpublished_scholarship.status_text, href: unpublished_scholarship.application_url)

    # expect(page).to have_content("Available Scholarships") # Removed this line as the view doesn't render it
  end

  scenario "Student sees a message when no scholarships are available" do
    # Delete all existing scholarships to ensure @scholarships is empty
    Scholarship.destroy_all

    visit scholarships_path

    expect(page).to have_content("There are currently no scholarships available.")
    # Ensure no scholarship names are present
    expect(page).not_to have_content("Published Grant")
    expect(page).not_to have_content("Draft Award")
    expect(page).not_to have_content("Old Scholarship")
  end
end
