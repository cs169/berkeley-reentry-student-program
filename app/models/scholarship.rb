# frozen_string_literal: true

require "csv"

class Scholarship < ApplicationRecord
  has_rich_text :description

  validates :name, presence: true
  validates :status_text, presence: true
  validates :application_url, format: { with: URI.regexp(%w[http https]), message: "must be a valid URL" }, allow_blank: true

  def self.to_csv
    attributes = %w[id name status_text application_url created_at updated_at]

    CSV.generate(headers: true) do |csv|
      csv << attributes + ["description"]

      all.each do |scholarship|
        values = attributes.map { |attr| scholarship.send(attr) }
        values << scholarship.description.to_plain_text
        csv << values
      end
    end
  end
end
