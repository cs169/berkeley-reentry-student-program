# app/models/event.rb
# frozen_string_literal: true

class Event < ApplicationRecord
  has_one_attached :flyer
  validates :title, :date, :start_time, :location, :description, presence: true
  validate :acceptable_flyer
  validate :end_time_after_start_time, if: -> { start_time.present? && end_time.present? }

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
      csv << column_names
      all.each { |event| csv << event.attributes.values_at(*column_names) }
    end
  end

  private

  def end_time_after_start_time
    return unless end_time <= start_time
    
    errors.add(:end_time, "must be after start time")
  end

  def acceptable_flyer
    return unless flyer.attached?

    # Validate file type
    unless flyer.content_type.start_with?('image/')
      errors.add(:flyer, 'must be an image file (JPEG, PNG, GIF, etc.)')
      flyer.purge # Remove the invalid attachment
    end

    # Validate file size
    if flyer.blob.byte_size > 5.megabytes
      errors.add(:flyer, 'is too large (maximum is 5MB)')
      flyer.purge # Remove the oversized attachment
    end
  end
end
