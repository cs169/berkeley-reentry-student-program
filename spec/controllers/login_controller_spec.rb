# frozen_string_literal: true

require "rails_helper"

RSpec.describe LoginController, type: :controller do
  describe "#canvas_login" do
    let(:canvas_url) { ENV["CANVAS_URL"] }
    let(:client_id) { ENV["CANVAS_CLIENT_ID"] }
    let(:redirect_uri) { ENV["CANVAS_REDIRECT_URI"] }

    before do
      stub_const("ENV", {
        "CANVAS_URL" => canvas_url,
        "CANVAS_CLIENT_ID" => client_id,
        "CANVAS_REDIRECT_URI" => redirect_uri
      })
    end

    it "redirects to Canvas OAuth2 authorization URL with correct parameters" do
      expected_params = {
        client_id: client_id,
        response_type: "code",
        redirect_uri: redirect_uri,
        scope: "url:GET|/api/v1/users/self"
      }

      expected_url = "#{canvas_url}/login/oauth2/auth?#{expected_params.to_query}"

      get :canvas_login

      expect(response).to redirect_to(expected_url)
      expect(response.status).to eq(302)
    end

    context "when environment variables are missing" do
      before do
        stub_const("ENV", {})
      end

      it "handles missing environment variables gracefully" do
        get :canvas_login
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq("Canvas configuration is missing")
      end
    end
  end
end
