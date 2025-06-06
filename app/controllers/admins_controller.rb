# frozen_string_literal: true

# handle all access from admin user
class AdminsController < ApplicationController
  before_action :check_permission
  before_action :set_scholarship, only: %i[edit update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :scholarship_not_found

  def index; end

  def view_checkin_records
    @checkin_records = Checkin.all
  end

  def manage_advisors
    @advisors = Advisor.all
  end

  def manage_scholarships
    @scholarships = Scholarship.all
    render "admins/scholarships/manage"
  end

  def manage_user_roles
    @users = User.all
  end

  def new
    @scholarship = Scholarship.new
    render "admins/scholarships/new"
  end

  def create
    @scholarship = Scholarship.new(scholarship_params)
    if @scholarship.save
      redirect_to manage_scholarships_path, notice: "Scholarship was successfully created."
    else
      flash.now[:alert] = "Failed to create scholarship."
      render "admins/scholarships/new", status: :unprocessable_entity
    end
  end

  def edit
    render "admins/scholarships/edit"
  end

  def update
    if @scholarship.update(scholarship_params)
      redirect_to manage_scholarships_path, notice: "Scholarship was successfully updated."
    else
      flash.now[:alert] = "Failed to update scholarship."
      render "admins/scholarships/edit", status: :unprocessable_entity
    end
  end

  def destroy
    @scholarship.destroy
    redirect_to manage_scholarships_path, notice: "Scholarship was successfully deleted."
  end

  def batch_delete
    scholarship_ids = params[:scholarship_ids]
    if scholarship_ids.present?
      Scholarship.where(id: scholarship_ids).destroy_all
      redirect_to manage_scholarships_path, notice: "Selected scholarships were successfully deleted."
    else
      redirect_to manage_scholarships_path, alert: "No scholarships were selected for deletion."
    end
  end

  def manage_courses
    @courses = Course.all
    render "admins/courses/manage" # Explicitly specify the template to render
  end

  def new_course
    @course = Course.new
    render "admins/courses/new"
  end

  def create_course
    @course = Course.new(course_params)
    if @course.save
      redirect_to manage_courses_path, notice: "Course was successfully created."
    else
      render "admins/courses/new"
    end
  end

  def edit_course
    @course = Course.find(params[:id])
    render "admins/courses/edit"
  end

  def update_course
    @course = Course.find(params[:id])
    if @course.update(course_params)
      redirect_to manage_courses_path, notice: "Course was successfully updated."
    else
      render "admins/courses/edit"
    end
  end

  def destroy_course
    @course = Course.find(params[:id])
    @course.destroy
    redirect_to manage_courses_path, notice: "Course was successfully deleted."
  end

  def export_courses
    @courses = Course.all
    respond_to do |format|
      format.csv { send_data Course.to_csv, filename: "courses-#{Date.today}.csv" }
    end
  end

  def export_scholarships
    @scholarships = Scholarship.all
    respond_to do |format|
      format.csv { send_data Scholarship.to_csv, filename: "scholarships-#{Date.today}.csv" }
    end
  end

  private
  def check_permission
    admin = Admin.find_by_id(session[:current_user_id])
    redirect_to root_path, flash: { error: "You don't have the permission to do that!" } if !admin || !admin.is_admin
  end

  def set_scholarship
    @scholarship = Scholarship.find(params[:id])
  end

  def scholarship_not_found
    redirect_to scholarships_path, alert: "Scholarship not found."
  end

  def scholarship_params
    params.require(:scholarship).permit(:name, :description, :status_text, :application_url)
  end

  def course_params
    params.require(:course).permit(:code, :title, :description, :units, :semester, :schedule, :ccn, :location, :available)
  end
end
