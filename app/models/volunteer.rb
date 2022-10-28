class Volunteer < ApplicationRecord
  belongs_to :person, optional: true
  belongs_to :event

  validates :role, presence: true
end
