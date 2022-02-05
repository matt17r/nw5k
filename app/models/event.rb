class Event < ApplicationRecord
  validates :date, presence: true
  validates :number, numericality: {only_integer: true, greater_than: 0}
end
