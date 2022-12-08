class Event < ApplicationRecord
  has_many :results
  has_many :results_with_historical_data, class_name: "ResultWithHistoricalData"
  has_many :volunteers

  validates :date, presence: true
  validates :number, numericality: {only_integer: true, greater_than: 0}

  def to_s
    "##{number} - #{date.to_fs(:short)}"
  end

  def to_param
    number.to_s
  end
end
