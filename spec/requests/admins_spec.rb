# frozen_string_literal: true

# spec/requests/admins_spec.rb

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
      patch update_scholarship_path(scholarship), params: { scholarship: { name: "Updated" } }
      expect(response).to redirect_to(manage_scholarships_path)
    end

    it "fails to update a scholarship with invalid data" do
      scholarship = FactoryBot.create(:scholarship)
      patch update_scholarship_path(scholarship), params: { scholarship: { name: "" } }
      expect(response).to render_template("admins/scholarships/edit")
    end

    it "deletes a scholarship" do
      scholarship = FactoryBot.create(:scholarship)
      delete destroy_scholarship_path(scholarship)
      expect(response).to redirect_to(manage_scholarships_path)
    end

    it "batch deletes scholarships" do
      scholarships = FactoryBot.create_list(:scholarship, 3)
      delete batch_delete_scholarships_path, params: { scholarship_ids: scholarships.map(&:id) }
      expect(response).to redirect_to(manage_scholarships_path)
    end

    it "handles batch delete with no selection" do
      delete batch_delete_scholarships_path
      expect(response).to redirect_to(manage_scholarships_path)
      follow_redirect!
      expect(response.body).to include("No scholarships were selected for deletion.")
    end

    it "allows managing courses" do
      get manage_courses_path
      expect(response).to have_http_status(:success)
    end

    it "shows new course form" do
      get new_course_path
      expect(response).to have_http_status(:success)
    end

    it "creates a course successfully" do
      post create_course_path, params: { course: { code: "CS101", title: "Intro to CS", description: "A course", units: 3, semester: "Fall", schedule: "MWF 10-11", ccn: "12345", location: "Room 101", available: true } }
      expect(response).to redirect_to(manage_courses_path)
    end

    it "updates a course successfully" do
      course = FactoryBot.create(:course)
      patch update_course_path(course), params: { course: { title: "Updated Title" } }
      expect(response).to redirect_to(manage_courses_path)
    end

    it "deletes a course" do
      course = FactoryBot.create(:course)
      delete destroy_course_path(course)
      expect(response).to redirect_to(manage_courses_path)
    end

    it "exports courses to CSV" do
      get export_courses_path(format: :csv)
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("text/csv")
    end

    it "exports scholarships to CSV" do
      get export_scholarships_path(format: :csv)
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("text/csv")
    end
  end
end
