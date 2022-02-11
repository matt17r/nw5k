class ResultsController < ApplicationController
  skip_before_action :authenticate_person!, only: [:index, :show]
  before_action :set_event

  def index
    @results = @event.results.order(:time)
  end

  def show
    @result = @event.results.find(params[:id])
  end

  def new
    @result = @event.results.new
  end

  def edit
    @result = @event.results.find(params[:id])
  end

  def create
    @result = @event.results.new(result_params)

    if @result.save
      redirect_to event_result_url(@event, @result), notice: "Result was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @result = @event.results.find(params[:id])
    if @result.update(result_params)
      redirect_to event_result_url(@event, @result), notice: "Result was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @result = @event.results.find(params[:id])
    @result.destroy
    redirect_to event_results_url(@event), notice: "Result was successfully destroyed."
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def result_params
    params.require(:result).permit(:person_id, :event_id, :time)
  end
end