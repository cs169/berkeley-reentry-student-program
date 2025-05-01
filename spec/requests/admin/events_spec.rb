# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Events", type: :request do
  let(:event) { create(:event) }

  before do
    admin = FactoryBot.create(:admin)
    sign_in_as(admin)
  end

  describe "GET /admin/events" do
    it "returns a successful response" do
      get admin_events_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /admin/events/new" do
    it "renders the new template" do
      get new_admin_event_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /admin/events" do
    let(:valid_params) do
      {
        event: {
          title: "Workshop",
          date: Date.today,
          start_time: "06:00 PM",
          location: "Innovation Lab",
          description: "Get information!"
        }
      }
    end

    let(:invalid_params) do
      { event: { title: "", date: "", start_time: "", location: "", description: "" } }
    end

    it "creates a new event with valid params" do
      expect {
        post admin_events_path, params: valid_params
      }.to change(Event, :count).by(1)
      expect(response).to redirect_to(admin_events_path)
      follow_redirect!
      expect(response.body).to include("Event created successfully.")
    end

    it "renders new template with invalid params" do
      post admin_events_path, params: invalid_params
      expect(response.body).to include("Missing values. Failed to create event.")
    end
  end

  describe "PATCH /admin/events/:id" do
    it "updates the event with valid data" do
      patch admin_event_path(event), params: { event: { title: "Updated Title" } }
      expect(response).to redirect_to(admin_events_path)
      follow_redirect!
      expect(response.body).to include("Event updated successfully.")
      expect(event.reload.title).to eq("Updated Title")
    end

    it "renders edit with invalid data" do
      patch admin_event_path(event), params: { event: { title: "" } }
      expect(response.body).to include("Failed to update event.")
    end
  end

  describe "DELETE /admin/events/:id" do
    let!(:deletable_event) { create(:event) }
    context "when the event is successfully deleted" do
      it "deletes the event and redirects" do
        expect {
          delete admin_event_path(deletable_event)
        }.to change(Event, :count).by(-1)
        expect(response).to redirect_to(admin_events_path)
      end
    end

    context "when the event cannot be deleted" do
      it "redirects to admin events path with an error message" do
        allow_any_instance_of(Event).to receive(:destroy).and_return(false)
        delete admin_event_path(event)
        expect(response).to redirect_to(admin_events_path)
        expect(flash[:error]).to eq("Failed to delete event.")
      end
    end

    context "when the event is not found" do
      it "redirects to admin events path with an alert" do
        delete admin_event_path(id: 99999) # Assuming event with ID 99999 doesn't exist
        expect(response).to redirect_to(admin_events_path)
        expect(flash[:alert]).to eq("Event not found.")
      end
    end
  end

  describe "GET /admin/events/:id" do
    it "redirects to index" do
      get admin_event_path(event)
      expect(response).to redirect_to(admin_events_path)
    end
  end

  describe "GET /admin/export_events.csv" do
    it "returns a CSV file" do
      get export_admin_events_path + ".csv"
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("text/csv")
      expect(response.body).to include("title,date,start_time,end_time,location,description")
    end
  end
end
