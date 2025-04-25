# frozen_string_literal: true

class LoginController < ApplicationController
  def confirm
    @user = User.find_by(id: session[:current_user_id])
    redirect_to root_path, flash: { error: "Please log-in first!" } if @user.nil?
  end

  def canvas_login
    unless Rails.application.credentials[:CANVAS_CLIENT_ID] && Rails.application.credentials[:CANVAS_URL]
      redirect_to root_path, flash: { error: "Canvas configuration is missing" }
      return
    end
    redirect_uri = "#{request.protocol}#{request.host_with_port}/auth/canvas/callback"
    params = {
      client_id: Rails.application.credentials[:CANVAS_CLIENT_ID],
      response_type: "code",
      redirect_uri: redirect_uri,
      scope: "url:GET|/api/v1/users/:id"
    }

    redirect_to "#{Rails.application.credentials[:CANVAS_URL]}/login/oauth2/auth?#{params.to_query}", allow_other_host: true
  end
end
