# frozen_string_literal: true

class Admin::EventsController < ApplicationController
  before_action :check_if_admin
  before_action :set_event, only: [:edit, :update, :show, :destroy]

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to admin_events_path, notice: "Event created successfully."
    else
      flash.now[:alert] = "Missing values. Failed to create event."
      render :new
    end
  end

  def edit
    # event set by set_event
  end

  def show
    # event set by set_event
    redirect_to admin_events_path
  end

  def update
    if @event.update(event_params)
      redirect_to admin_events_path, notice: "Event updated successfully."
    else
      flash.now[:alert] = 'Failed to update event.'
      render :edit
    end
  end

  def destroy
    Rails.logger.debug("PARAMS: #{params.inspect}")
    Rails.logger.debug("REQUEST METHOD: #{request.method}")
    if @event.destroy
      redirect_to admin_events_path, flash: { success: "Event deleted successfully." }
    else
      redirect_to admin_events_path, flash: { error: "Failed to delete event." }
    end
  end

  private
  def event_params
    params.require(:event).permit(:title, :date, :start_time, :end_time, :location, :description, :flyer) # may change later, not sure what we want to include
  end

  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_events_path, alert: "Event not found."
  end
end
