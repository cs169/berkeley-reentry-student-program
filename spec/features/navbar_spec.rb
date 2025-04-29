# frozen_string_literal: true

# spec/system/navbar_spec.rb
require "rails_helper"

RSpec.describe "Navbar hamburger menu", type: :system do
  it "shows hamburger menu and opens it when clicked" do
    driven_by(:selenium_chrome_headless) # or :selenium_chrome

    visit root_path

    # Resize the window to simulate mobile view
    page.driver.browser.manage.window.resize_to(500, 800)

    # Check hamburger is visible
    expect(page).to have_selector(".navbar-toggler", visible: true)

    # Click hamburger
    find(".navbar-toggler").click

    # After clicking, the nav menu should appear
    expect(page).to have_selector(".navbar-collapse.show")
  end
end
