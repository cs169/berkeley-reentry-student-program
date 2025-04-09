# frozen_string_literal: true

class Advisor < ApplicationRecord
  validates :name, :description, :active, presence: true
  validates :calendar, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }, allow_blank: true
end
