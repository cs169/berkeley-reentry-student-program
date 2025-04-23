# frozen_string_literal: true

require "rails_helper"

RSpec.describe Event, type: :model do
  describe "validations" do
    it "is valid with all required attributes" do
      event = Event.new(
        title: "Study Jam",
        date: Date.today,
        start_time: Time.now,
        location: "RSP Community Space",
        description: "Join us for a group study session with free cookies!"
      )
      expect(event).to be_valid
    end

    it "is invalid without a title" do
      event = Event.new(date: Date.today, start_time: Time.now, location: "Library", description: "Study")
      expect(event).not_to be_valid
      expect(event.errors[:title]).to include("Title cannot be empty")
    end

    it "is invalid without a date" do
      event = Event.new(title: "Study", start_time: Time.now, location: "Library", description: "Study")
      expect(event).not_to be_valid
      expect(event.errors[:date]).to include("Date cannot be empty")
    end

    it "is invalid without a start_time" do
      event = Event.new(title: "Study", date: Date.today, location: "Library", description: "Study")
      expect(event).not_to be_valid
      expect(event.errors[:start_time]).to include("Start time cannot be empty")
    end

    it "is invalid without a location" do
      event = Event.new(title: "Study", date: Date.today, start_time: Time.now, description: "Study")
      expect(event).not_to be_valid
      expect(event.errors[:location]).to include("Location cannot be empty")
    end

    it "is invalid without a description" do
      event = Event.new(title: "Study", date: Date.today, start_time: Time.now, location: "Library")
      expect(event).not_to be_valid
      expect(event.errors[:description]).to include("Description cannot be empty")
    end
  end

  describe "#formatted_time" do
    it "returns time range if end_time exists" do
      event = Event.new(
        start_time: Time.parse("10:00 AM"),
        end_time: Time.parse("12:00 PM")
      )
      expect(event.formatted_time).to eq("10:00 AM - 12:00 PM")
    end

    it "returns only start_time if end_time is missing" do
      event = Event.new(start_time: Time.parse("10:00 AM"))
      expect(event.formatted_time).to eq("10:00 AM")
    end
  end

  describe "#formatted_date" do
    it "returns the formatted date string" do
      event = Event.new(date: Date.new(2025, 5, 1))
      expect(event.formatted_date).to eq("Thursday, May 01, 2025")
    end
  end

  describe ".to_csv" do
    context "when there are no events" do
      it "returns a CSV with only headers" do
        Event.delete_all
        csv_output = Event.to_csv
        rows = csv_output.split("\n")
        expect(rows.length).to eq(1)
        expect(rows.first).to include("id", "title", "date", "start_time", "end_time", "location", "description")
      end
    end

    context "when there is one event" do
      it "returns a CSV with headers and the event data" do
        event = Event.create!(
          title: "Hackathon",
          date: Date.today,
          start_time: Time.now,
          location: "Main Hall",
          description: "24-hour coding event"
        )

        csv_output = Event.to_csv
        rows = csv_output.split("\n")

        expect(rows.length).to eq(2)
        expect(rows.first).to include("id", "title", "date", "start_time", "end_time", "location", "description")
        expect(rows.last).to include(event.id.to_s, event.title, event.date.to_s, event.start_time.strftime("%H:%M:%S"), event.location, event.description)
      end
    end

    context "when there are multiple events" do
      it "returns a CSV with headers and all event data" do
        event1 = Event.create!(
          title: "RSP Gala",
          date: Date.today,
          start_time: Time.now,
          location: "Main Hall",
          description: "Fun social night event to network with other re-entry students"
        )

        event2 = Event.create!(
          title: "Workshop",
          date: Date.tomorrow,
          start_time: Time.now,
          end_time: Time.now + 1.hour,
          location: "Room 101",
          description: "Tech workshop"
        )

        csv_output = Event.to_csv
        rows = csv_output.split("\n")
        expect(rows.length).to eq(3)
        expect(rows.first).to include("id", "title", "date", "start_time", "end_time", "location", "description")
        expect(rows[1]).to include(event1.id.to_s, event1.title, event1.date.to_s, event1.start_time.strftime("%H:%M:%S"), event1.location, event1.description)
        expect(rows[2]).to include(event2.id.to_s, event2.title, event2.date.to_s, event2.start_time.strftime("%H:%M:%S"), event2.end_time.strftime("%H:%M:%S"), event2.location, event2.description)
      end
    end
  end
end
