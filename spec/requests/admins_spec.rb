# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admins", type: :request do
  describe "Access control" do
    it "blocks Student from accessing admin dashboard" do
      student = FactoryBot.create(:student)
      post login_path, params: { sid: student.sid }
      get admins_path
      expect(response).to redirect_to(root_path)
    end

    it "blocks Staff from accessing admin dashboard" do
      staff = FactoryBot.create(:staff)
      post login_path, params: { sid: staff.sid }
      get admins_path
      expect(response).to redirect_to(root_path)
    end

    it "blocks logged-out user from accessing admin dashboard" do
      get admins_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "Viewing check-in records" do
    let(:admin) { FactoryBot.create(:admin) }

    before do
      post login_path, params: { sid: admin.sid }
      50.times { FactoryBot.create(:checkin) }
    end

    it "redirects to page 1 when page param is missing" do
      get view_checkin_records_path
      expect(response).to redirect_to(view_checkin_records_path(page: 1))
    end

    it "returns has_next_page: false on the last page" do
      last_page = (Checkin.count / 20.0).ceil
      get view_checkin_records_path(page: last_page)

      # Example: checking HTML or assigning in controller (adjust as needed)
      expect(response.body).to include("No more pages") # Adjust if rendering has indicator
    end
  end
end
