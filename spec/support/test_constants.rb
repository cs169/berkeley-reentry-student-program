# frozen_string_literal: true

# Define constants centrally to avoid redefinition and warnings
module TestConstants
  # Student test credentials
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
  }.freeze
end

# Include this module in RSpec configuration to make constants globally available
RSpec.configure do |config|
  config.include TestConstants
end
