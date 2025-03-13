# frozen_string_literal: true

FactoryBot.define do
  factory :appointment do
    Time.zone = "Pacific Time (US & Canada)"
    time { DateTime.now + 1.day }
    location { "ESS" }
    association :staff, factory: :staff
    student { nil }
  end
end
