# app/models/event.rb
# frozen_string_literal: true

class Event < ApplicationRecord
  validates :title, :date, :start_time, :location, :description, presence: {message: "%{attribute} cannot be empty"}

  # Helper method for displaying formatted time range
  def formatted_time
    if end_time.present?
      "#{start_time.strftime('%l:%M %p').strip} - #{end_time.strftime('%l:%M %p').strip}"
    else
      start_time.strftime("%l:%M %p").strip
    end
  end

  # Helper method for displaying formatted date
  def formatted_date
    date.strftime("%A, %B %d, %Y")
  end

  def self.to_csv
    require "csv"
    CSV.generate(headers: true) do |csv|
      columns = %w[title date start_time end_time location description]
      csv << columns
      all.order(date: :desc).each do |event|
        csv << event.attributes.values_at(*columns)
      end
    end
  end
end
