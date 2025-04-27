# frozen_string_literal: true

FactoryBot.define do
  factory :scholarship do
    name { "MyString" }
    description { "MyText" }
    status_text { "MyString" }
    application_url { "https://example.com/apply" }
  end
end
