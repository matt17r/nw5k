class Admin < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true

  has_secure_password
  has_secure_token :remember_token

  private

  def downcase_email
    self.email = email.downcase
  end
end
