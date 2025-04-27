# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    title { "Sample Event" }
    description { "An amazing event" }
    location { "Berkeley Campus" }
    date { Date.today + 1.week }
    start_time { Time.parse("10:00AM") }
    end_time { Time.parse("12:00PM") }
  end
end
