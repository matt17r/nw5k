class Result < ApplicationRecord
  WORLD_RECORD_TIME_5000M = 755

  belongs_to :person, optional: true
  belongs_to :event

  validates :time, numericality: {only_integer: true, greater_than: WORLD_RECORD_TIME_5000M}
end
