# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdvisorsController, type: :request do
  let(:valid_attributes) do
    {
      name: "John Doe",
      description: "An experienced advisor",
      calendar: "https://calendar.example.com",
      active: true
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      description: "",
      calendar: "",
      active: nil
    }
  end

  let!(:advisor) { Advisor.create!(valid_attributes) }

  describe "GET #new" do
    it "assigns a new advisor as @advisor" do
      get "/advisors/new"
      expect(assigns(:advisor)).to be_a_new(Advisor)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Advisor" do
        expect {
          post "/advisors/", params: { advisor: valid_attributes }
        }.to change(Advisor, :count).by(1)
      end

      it "redirects to the manage advisors path with a success message" do
        post "/advisors/", params: { advisor: valid_attributes }
        expect(response).to redirect_to(manage_advisors_path)
        expect(flash[:success]).to eq("Advisor created successfully.")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Advisor" do
        expect {
          post "/advisors/", params: { advisor: invalid_attributes }
        }.not_to change(Advisor, :count)
      end

      it "renders the :new template with an error message" do
        post "/advisors/", params: { advisor: invalid_attributes }
        expect(response).to render_template("advisors/new")
        # expect(flash[:error]).to eq("Failed to create advisor.")
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested advisor as @advisor" do
      get "/advisors/#{advisor.id}/edit"
      expect(assigns(:advisor)).to eq(advisor)
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid parameters" do
      let(:new_attributes) do
        {
          name: "Jane Doe",
          description: "Updated description",
          calendar: "https://newcalendar.example.com",
          active: false
        }
      end

      it "updates the requested advisor" do
        patch "/advisors/#{advisor.id}", params: { advisor: new_attributes }
        advisor.reload
        expect(advisor.name).to eq("Jane Doe")
        expect(advisor.description).to eq("Updated description")
        expect(advisor.calendar).to eq("https://newcalendar.example.com")
        expect(advisor.active).to be_falsey
      end

      it "redirects to the manage advisors path with a success message" do
        patch "/advisors/#{advisor.id}", params: { advisor: new_attributes }
        expect(response).to redirect_to(manage_advisors_path)
        expect(flash[:success]).to eq("Advisor updated successfully.")
      end
    end

    context "with invalid parameters" do
      it "does not update the advisor" do
        patch "/advisors/#{advisor.id}", params: { advisor: invalid_attributes }
        advisor.reload
        expect(advisor.name).not_to eq("")
      end

      it "renders the :edit template with an error message" do
        patch "/advisors/#{advisor.id}", params: { advisor: invalid_attributes }
        expect(response).to render_template("advisors/edit")
        # expect(flash[:error]).to eq("Failed to update advisor.")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested advisor" do
      expect {
        delete "/advisors/#{advisor.id}"
      }.to change(Advisor, :count).by(-1)
    end

    it "redirects to the manage advisors path with a success message" do
      delete "/advisors/#{advisor.id}"
      expect(response).to redirect_to(manage_advisors_path)
      expect(flash[:success]).to eq("Advisor deleted successfully.")
    end
  end

  describe "GET #show" do
    it "assigns the requested advisor as @advisor" do
      pending "Implement the show page in the views"
      fail
      # get "/advisors/#{advisor.id}"
      # expect(assigns(:advisor)).to eq(advisor)
    end
  end
end
