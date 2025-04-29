# frozen_string_literal: true

FactoryBot.define do
    factory :course do
      code { "CS169L" }
      title { "Software Engineering Team Project" }
      description { "Open-ended design project." }
      units { 4 }
      semester { "Spring" }
      schedule { "MF 10:30am-12pm" }
      ccn { "12345" }
      location { "Soda 405" }
      available { true }
    end
  end
