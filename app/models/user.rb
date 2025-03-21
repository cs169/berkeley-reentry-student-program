# frozen_string_literal: true

class User < ApplicationRecord
  validates :first_name, :last_name, :email, presence: true
  encrypts :google_token, :google_refresh_token, :canvas_token, :canvas_refresh_token
  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |user|
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
    end
  end

  def name
    "#{first_name} #{last_name}"
  end
end
