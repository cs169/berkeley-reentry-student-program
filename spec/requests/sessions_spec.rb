# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Canvas Authentication", type: :request do
  describe "GET /auth/canvas/callback with MOCK_CANVAS_LOGIN" do
    let(:mock_student_email) { "studentuser@berkeley.edu" }
    let(:mock_admin_email) { "169reentryadmin@berkeley.edu" }

    around do |example|
      original_mock_value = ENV["MOCK_CANVAS_LOGIN"]
      ENV["MOCK_CANVAS_LOGIN"] = "true"
      example.run
      ENV["MOCK_CANVAS_LOGIN"] = original_mock_value
    end

    before do
      # Prevent DB locking and constraint issues
      User.delete_all
      # Stub Rails credentials to avoid relying on encrypted config in test
      allow(Rails.application.credentials).to receive(:[]).with(:ADMINS).and_return(mock_admin_email)
      allow(Rails.application.credentials).to receive(:[]).with(:STAFF).and_return("none")
    end

    it "creates and logs in a mock student user" do
      expect {
        get "/auth/canvas/callback", params: { mock_role: "student" }
      }.to change { User.count }.by(1)

      user = User.last
      expect(user.email).to eq(mock_student_email)
      expect(user.is_student).to be true
      expect(user.is_admin).to be false
      expect(user.is_staff).to be false
      expect(session[:current_user_id]).to eq(user.id)
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Logged in as Student mock user")
    end

    it "creates and logs in a mock admin user" do
      expect {
        get "/auth/canvas/callback", params: { mock_role: "admin" }
      }.to change { User.count }.by(1)

      user = User.last
      expect(user.email).to eq(mock_admin_email)
      expect(user.is_admin).to be true
      expect(user.is_student).to be false
      expect(user.is_staff).to be false
      expect(session[:current_user_id]).to eq(user.id)
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Logged in as Admin mock user")
    end
  end
end
