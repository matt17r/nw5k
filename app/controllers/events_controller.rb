class EventsController < ApplicationController
  skip_before_action :authenticate_admin!, only: [:index, :show, :show_latest]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.all.order(number: :desc).includes(:results)
  end

  def recalculate_results
    ResultWithHistoricalData.refresh # This probably belongs in an async after_commit callback with a built in delay, but this will do for now
    redirect_back(fallback_location: results_path)
  end

  def show
    return redirect_to results_path unless @event.present?
    @five_k_results = @event.results_with_historical_data.distance_5km.order(:time).includes(:person)
    @two_mi_results = @event.results_with_historical_data.distance_2miles.order(:time).includes(:person)
    @volunteers = @event.volunteers.order(:role).includes(:person)
  end

  def show_latest
    @event = Event.order(number: :desc).first
    redirect_to event_url(@event)
  end

  def new
    event_num = Event.maximum(:number).next
    @event = Event.new(number: event_num)
  end

  def edit
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to new_event_result_url(@event), notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url, notice: "Event was successfully destroyed."
  end

  private

  def set_event
    @event = Event.find_by number: params[:number]
  end

  def event_params
    params.require(:event).permit(:date, :number)
  end
end
