# frozen_string_literal: true

FactoryBot.define do
  factory :checkin do
    Time.zone = "Pacific Time (US & Canada)"
    time { Time.now }
    reason { "Studying" }
    association :student, factory: :student
  end
end
