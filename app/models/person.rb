class Person < ApplicationRecord
  before_save :downcase_email

  has_many :results

  validates :name, presence: true
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true

  has_secure_password
  has_secure_token :remember_token

  def to_s
    "#{emoji} #{nickname}"
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
