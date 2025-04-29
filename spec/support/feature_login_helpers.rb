# frozen_string_literal: true

# Helper methods for logging in within feature specs
module FeatureLoginHelpers
  # Standard Google OAuth2 mock hash
  STUDENT_GOOGLE_MOCK = {
    "provider" => "google_oauth2",
    "uid" => "1000000000",
    "info" => {
      "name" => "Google Test Developer",
      "email" => "google_student@berkeley.edu", # Ensure this matches the test user's email
      "first_name" => "Google",
      "last_name" => "Test Developer"
    },
    "credentials" => {
      "token" => "credentials_token_1234567",
      "refresh_token" => "credentials_refresh_token_45678"
    }
  }.freeze

  def login_with_google(user)
    # Update mock hash email to match the specific user being logged in
    mock_hash = STUDENT_GOOGLE_MOCK.deep_dup
    mock_hash["info"]["email"] = user.email
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(mock_hash)

    # Simulate the login process
    visit root_path
    click_button "Login with Google"
  end
end

RSpec.configure do |config|
  config.include FeatureLoginHelpers, type: :feature
end
