class EventsController < ApplicationController
  skip_before_action :authenticate_admin!, only: [:index, :show, :show_latest]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.all.order("number DESC").includes(:results)
  end

  def show
    @results = @event.results.order("time ASC").includes(:person)
  end

  def show_latest
    @event = Event.order("number DESC").first
    @results = @event.results.order("time ASC").includes(:person)
    render :show
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
