class Result < ApplicationRecord
  belongs_to :person, optional: true
  belongs_to :event

  validates :time, numericality: {
    only_integer: true,
    greater_than: ResultsHelper::MINIMUM_TIME,
    less_than_or_equal_to: ResultsHelper::MAXIMUM_TIME,
    allow_nil: true
  }
end
