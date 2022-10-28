class VolunteersController < ApplicationController
  skip_before_action :authenticate_admin!, only: [:index, :show]
  before_action :set_event

  def index
    @volunteers = @event.volunteers.order(:role)
  end

  def show
    @volunteer = @event.volunteers.find(params[:id])
  end

  def new
    @volunteer = @event.volunteers.new
  end

  def edit
    @volunteer = @event.volunteers.find(params[:id])
  end

  def create
    @volunteer = @event.volunteers.new(volunteer_params)

    if @volunteer.save
      redirect_to event_volunteers_url(@event), notice: "Volunteer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @volunteer = @event.volunteers.find(params[:id])
    if @volunteer.update(volunteer_params)
      redirect_to event_volunteers_url(@event), notice: "Volunteer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @volunteer = @event.volunteers.find(params[:id])
    @volunteer.destroy
    redirect_to event_volunteers_url(@event), notice: "Volunteer was successfully destroyed."
  end

  private

  def set_event
    @event = Event.find_by number: params[:event_number]
  end

  def volunteer_params
    params.require(:volunteer).permit(:person_id, :event_id, :role)
  end
end
