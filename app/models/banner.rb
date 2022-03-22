class Banner < ApplicationRecord
  validates :title, presence: true
  validates :publish_at, presence: true
  validates :withdraw_at, presence: true

  attribute :publish_at, :datetime, default: -> { Time.now }
  attribute :withdraw_at, :datetime, default: -> { Time.now + 7.days }

  scope :current, -> {
    where("publish_at <= :now AND withdraw_at >= :now", {now: Time.now})
      .order(withdraw_at: :asc)
      .order(publish_at: :asc)
      .order(updated_at: :desc)
  }
end
