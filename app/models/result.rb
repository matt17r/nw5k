class Result < ApplicationRecord
  belongs_to :person, optional: true
  belongs_to :event

  validates :time, numericality: {
    only_integer: true,
    greater_than: ResultsHelper::MINIMUM_TIME,
    less_than_or_equal_to: ResultsHelper::MAXIMUM_TIME,
    allow_nil: true
  }

  def place
    event.results.where("time < ?", time).count + 1
  end

  def pb?
    previous_best = person.results.order(:time).joins(:event).where("events.number < ?", event.number).first&.time
    time && previous_best && time < previous_best
  end
end
