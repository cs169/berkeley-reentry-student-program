# frozen_string_literal: true

class ScholarshipsController < ApplicationController
  before_action :require_login
  before_action :check_admin_permission, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_scholarship, only: [:show, :edit, :update, :destroy]

  # GET /scholarships (replaces the original index)
  def index
    @scholarships = Scholarship.all
    # Add pagination if necessary
  end

  # GET /scholarships/:id/edit (from admin)
  def edit
    # @scholarship is set by set_scholarship
  end

  # PATCH/PUT /scholarships/:id (from admin)
  def update
    if @scholarship.update(scholarship_params)
      flash[:notice] = "Scholarship updated successfully."
      redirect_to manage_scholarships_path
    else
      flash.now[:alert] = "Failed to update scholarship."
      render "admins/scholarships/edit", status: :unprocessable_entity
    end
  end

  # GET /scholarships/new (from admin)
  def new
    @scholarship = Scholarship.new
  end

  # POST /scholarships (from admin)
  def create
    @scholarship = Scholarship.new(scholarship_params)
    if @scholarship.save
      flash[:notice] = "Scholarship created successfully."
      redirect_to manage_scholarships_path
    else
      flash.now[:alert] = "Failed to create scholarship."
      render "admins/scholarships/new", status: :unprocessable_entity
    end
  end

  # DELETE /scholarships/:id (from admin)
  def destroy
    @scholarship.destroy
    flash[:notice] = "Scholarship deleted successfully."
    redirect_to manage_scholarships_path
  end

  # If you need a show action
  def show
    render plain: "Scholarship details for #{@scholarship.name}"
  end

  private
  def require_login
    unless session.key?(:current_user_id) && Student.find_by_id(session[:current_user_id])
      redirect_to root_path, flash: { error: "Please log in first!" }
    end
  end

  def set_scholarship
    @scholarship = Scholarship.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Scholarship not found."
    redirect_to scholarships_path
  end

  def scholarship_params
    params.require(:scholarship).permit(:name, :description, :status_text, :application_url)
  end

  def check_admin_permission
    admin = Admin.find_by_id(session[:current_user_id])
    unless admin
      redirect_to root_path, flash: { error: "You don\'t have the permission to do that!" }
    end
  end
end
