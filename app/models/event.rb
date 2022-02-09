class Event < ApplicationRecord
  has_many :results

  validates :date, presence: true
  validates :number, numericality: {only_integer: true, greater_than: 0}

  def to_s
    "#{number} - #{date}"
  end
end
