# frozen_string_literal: true
#spec/requests/admins_spec.rb

require "rails_helper"

RSpec.describe "Admins", type: :request do
  def sign_in_as(user)
    post "/__test_login", params: { id: user.id }
  end

  let(:admin) { FactoryBot.create(:admin) }

  describe "Access control" do
    it "blocks a student from accessing the admin dashboard" do
      student = FactoryBot.create(:student)
      sign_in_as(student)
      get admins_path
      expect(response).to redirect_to(root_path)
    end

    it "blocks a staff member from accessing the admin dashboard" do
      staff = FactoryBot.create(:staff)
      sign_in_as(staff)
      get admins_path
      expect(response).to redirect_to(root_path)
    end

    it "blocks a logged out user from accessing the admin dashboard" do
      get admins_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "Admin dashboard access" do
    before { sign_in_as(admin) }

    it "allows an admin to access the dashboard" do
      get admins_path
      expect(response).to have_http_status(:success)
    end

    it "allows viewing checkin records" do
      get view_checkin_records_path
      expect(response).to have_http_status(:success)
    end

    it "allows managing advisors" do
      get manage_advisors_path
      expect(response).to have_http_status(:success)
    end

    it "allows managing scholarships" do
      get manage_scholarships_path
      expect(response).to have_http_status(:success)
    end

    it "allows managing user roles" do
      get manage_user_roles_path
      expect(response).to have_http_status(:success)
    end

    it "shows new scholarship form" do
      get new_scholarship_path
      expect(response).to have_http_status(:success)
    end

    it "creates a scholarship successfully" do
      post create_scholarship_path, params: { scholarship: { name: "Test", description: "desc", status_text: "Active", application_url: "https://example.com" } }
      expect(response).to redirect_to(manage_scholarships_path)
    end

    it "fails to create a scholarship with invalid data" do
      post create_scholarship_path, params: { scholarship: { name: "" } }
      expect(response).to render_template("admins/scholarships/new")
    end

    it "shows edit scholarship form" do
      scholarship = FactoryBot.create(:scholarship)
      get edit_scholarship_path(scholarship)
      expect(response).to have_http_status(:success)
    end

    it "updates a scholarship successfully" do
      scholarship = FactoryBot.create(:scholarship)
      patch update_scholarship_path(scholarship), params: { scholarship: { name:
