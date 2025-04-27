# frozen_string_literal: true
#spec/requests/events_spec.rb

require "rails_helper"

RSpec.describe "Events", type: :request do
  # Helper to sign in a student
  def sign_in_as(student)
    post "/__test_login", params: { id: student.id }
  end

  describe "GET /events" do
    context "when user is logged in" do
      it "renders the index page successfully" do
        student = FactoryBot.create(:student)
        sign_in_as(student)

        get events_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Events")
      end

      it "assigns upcoming and past events" do
        student = FactoryBot.create(:student)
        sign_in_as(student)

        upcoming_event = FactoryBot.create(:event, date: Date.today + 5.days)
        past_event = FactoryBot.create(:event, date: Date.today - 5.days)

        get events_path

        expect(assigns(:upcoming_events)).to include(upcoming_event)
        expect(assigns(:past_events)).to include(past_event)
      end
    end

    context "when user is not logged in" do
      it "redirects to root path with an error" do
        get events_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Please log in first!")
      end
    end
  end
end
