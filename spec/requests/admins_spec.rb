# frozen_string_literal: true

# spec/requests/admins_spec.rb
require "rails_helper"

RSpec.describe "Admins", type: :request do
  describe "Access control for admin dashboard" do
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
end
