class Person < ApplicationRecord
  before_validation :strip_spaces
  before_save :downcase_email

  has_many :results

  validates :name, presence: true
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP, message: "must contain a correctly formatted email address"}
  validates :emoji, allow_blank: true, format: {with: Unicode::Emoji::REGEX_VALID, message: "can only contain valid emoji sequences"}
  validate :emoji_length
  validate :emoji_recommended

  has_secure_password
  has_secure_token :remember_token

  def to_s
    "#{emoji} #{nickname}".strip
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def emoji_length
    if emoji.present? && emoji.grapheme_clusters.length > 1
      errors.add(:emoji, "can only contain 1 emoji")
    end
  end

  def emoji_recommended
    puts "\n#{emoji.scan(Unicode::Emoji::REGEX_VALID)} -> #{emoji.scan(Unicode::Emoji::REGEX)}:\n\tLength:\t\t#{emoji.length}\n\tMatch length:\t#{emoji.scan(Unicode::Emoji::REGEX).length}"
    if emoji.present? && emoji.scan(Unicode::Emoji::REGEX_VALID).length > emoji.scan(Unicode::Emoji::REGEX).length
      errors.add(:emoji, "is a valid sequence but is not a recommended combination")
    end
  end

  def strip_spaces
    self.name = name&.strip
    self.email = email&.strip
    self.emoji = emoji&.strip
  end
end
