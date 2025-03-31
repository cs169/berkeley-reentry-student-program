# frozen_string_literal: true

require "rails_helper"

ADMIN_CREDENTIALS = {
  "provider" => "google_oauth2",
  "uid" =>      "1000000000",
  "info" =>     {
    "name" =>       "Google Admin Developer",
    "email" =>      "google_admin@berkeley.edu",
    "first_name" => "Google",
    "last_name" =>  "Admin Developer"
  },
  "credentials" => {
    "token" => "credentials_token_1234567",
    "refresh_token" => "credentials_refresh_token_45678"
  }
}

describe SessionsController do
  before(:each) do
    stub_const("ENV", { "ADMINS" => "google_admin@berkeley.edu", "STAFF" => "google_staff@berkeley.edu" })
  end
  describe "google authentication" do
    it "should create a new user" do
      user_len = User.all.size
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      get :google_auth
      expect(User.all.size).to be user_len + 1
    end
  end
  describe "logout" do
    it "should delete session key" do
      user = FactoryBot.create(:user)
      controller.session[:current_user_id] = user.id
      get :google_auth_logout
      expect(controller.session[:current_user_id]).to be_nil
    end
  end
  describe "admin login" do
    it "should create an admin" do
      admin_len = Admin.all.size
      OmniAuth.config.add_mock(
        :google_oauth2,
        ADMIN_CREDENTIALS
      )
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      get :google_auth
      expect(Admin.all.size).to be admin_len + 1
    end
    it "should recover on empty admins" do
      stub_const("ENV", { "ADMINS" => "", "STAFF" => "google_staff@berkeley.edu" })
      OmniAuth.config.add_mock(
        :google_oauth2,
        ADMIN_CREDENTIALS
      )
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      get :google_auth
      expect(flash[:error]).to match(/Something went wrong, please try again later./)
    end
  end
end

RSpec.describe SessionsController, type: :controller do
  describe "#canvas_callback" do
    let(:canvas_url) { ENV["CANVAS_URL"] }
    let(:client_id) { ENV["CANVAS_CLIENT_ID"] }
    let(:client_secret) { ENV["CANVAS_CLIENT_SECRET"] }
    let(:code) { "code" }
    let(:access_token) { double("AccessToken", token: "valid_token") }
    let(:user_data) do
      {
        "id" => 1,
        "name" => "Test User",
        "first_name" => "Test",
        "last_name" => "User",
        "email" => "test@berkeley.edu",
        "sis_user_id" => "123456",
      }
    end

    before do
      stub_const("ENV", {
        "CANVAS_URL" => canvas_url,
        "CANVAS_CLIENT_ID" => client_id,
        "CANVAS_CLIENT_SECRET" => client_secret,
        "ADMINS" => "admin@berkeley.edu",
        "STAFF" => "staff@berkeley.edu"
      })
    end

    context "with valid authentication code" do
      before do
        allow_any_instance_of(OAuth2::Client).to receive_message_chain(:auth_code, :get_token)
          .and_return(access_token)

        stub_request(:get, "#{canvas_url}/api/v1/users/self?")
          .with(headers: { "Authorization" => "Bearer #{access_token.token}" })
          .to_return(status: 200, body: user_data.to_json)
      end

      it "creates a new user and logs them in" do
        post :canvas_callback, params: { code: code }

        expect(User.count).to eq(1)
        user = User.last
        expect(user.email).to eq(user_data["email"])
        expect(session[:current_user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to eq("Success! You've been logged-in!")
      end

      it "logs in existing user without creating new record" do
        existing_user = User.create!(first_name: user_data["first_name"], last_name: user_data["last_name"], email: user_data["email"])
        expect {
          post :canvas_callback, params: { code: code }
        }.not_to change(User, :count)

        expect(session[:current_user_id]).to eq(existing_user.id)
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to eq("Success! You've been logged-in!")
      end
    end

    context "with invalid authentication" do
      it "handles missing code parameter" do
        post :canvas_callback

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Authentication failed. Please try again.")
      end

      it "handles error parameter" do
        post :canvas_callback, params: { error: "access_denied" }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Authentication failed. Please try again.")
      end
    end

    context "when Canvas API call fails" do
      before do
        allow_any_instance_of(OAuth2::Client).to receive_message_chain(:auth_code, :get_token)
          .and_return(access_token)

        stub_request(:get, "#{canvas_url}/api/v1/users/self?")
          .with(headers: { "Authorization" => "Bearer #{access_token.token}" })
          .to_return(status: 401)
      end
    end
  end
end
