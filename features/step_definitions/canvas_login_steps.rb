# frozen_string_literal: true

Given("the Canvas configuration is missing") do
  # Clear environment variables
  ENV["CANVAS_CLIENT_ID"] = nil
  ENV["CANVAS_URL"] = nil
  ENV["CANVAS_REDIRECT_URI"] = nil
end

When("I authorize the application") do
  # Simulate Canvas OAuth callback
  oauth_code = "valid_code"
  visit "/auth/canvas/callback?code=#{oauth_code}"
end

When("I deny the authorization") do
  visit "/auth/canvas/callback?error=access_denied"
end

Then("I should be redirected to Canvas for authentication") do
  expect(current_url).to include("#{ENV['CANVAS_URL']}/login/oauth2/auth")
  expect(current_url).to include("client_id=#{ENV['CANVAS_CLIENT_ID']}")
  expect(current_url).to include("redirect_uri=#{CGI.escape(ENV['CANVAS_REDIRECT_URI'])}")
  expect(current_url).to include("response_type=code")
end

When("I click the button \"Login with Canvas\"") do
  click_link_or_button("Login with Canvas")
end
