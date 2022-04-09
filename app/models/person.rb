class Person < ApplicationRecord
  PROBLEMATIC_EMOJI_IN_UNICODE_EMOJI_GEM_V3_1_0 = ["👨‍👩‍👧‍👦", "👨‍👩‍👦‍👦", "👨‍👩‍👧‍👧", "👨‍👨‍👧‍👦", "👨‍👨‍👦‍👦", "👨‍👨‍👧‍👧", "👩‍👩‍👧‍👦", "👩‍👩‍👦‍👦", "👩‍👩‍👧‍👧", "👨‍👦‍👦", "👨‍👧‍👦", "👨‍👧‍👧", "👩‍👦‍👦", "👩‍👧‍👦", "👩‍👧‍👧"]
  EMOJI_REQUIREMENTS = "(if present) must be a single emoji, must be from the list of RGI (recommended) emojis and must be in emoji, not text, presentation (e.g. ✌️ not ✌︎)".freeze

  before_validation :strip_spaces
  before_save :downcase_email

  has_many :results

  validates :name, presence: true
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP, message: "must contain a correctly formatted email address"}
  validates :emoji, allow_blank: true, format: {with: Unicode::Emoji::REGEX_VALID, message: EMOJI_REQUIREMENTS}
  validate :single_emoji_only
  validate :recommended_emoji_only
  validate :public_representation_present

  has_secure_password
  has_secure_token :remember_token

  def to_s
    "#{emoji} #{nickname}".strip
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def single_emoji_only
    if emoji.present? && emoji.grapheme_clusters.length > 1
      errors.add(:emoji, EMOJI_REQUIREMENTS)
    end
  end

  def recommended_emoji_only
    return if PROBLEMATIC_EMOJI_IN_UNICODE_EMOJI_GEM_V3_1_0.include? emoji # Temporary short circuit on problematic emoji - https://github.com/janlelis/unicode-emoji/issues/12
    if emoji.present? && emoji.scan(Unicode::Emoji::REGEX_VALID).present? && emoji.scan(Unicode::Emoji::REGEX_VALID)[0].length > emoji.scan(Unicode::Emoji::REGEX)[0].length
      errors.add(:emoji, EMOJI_REQUIREMENTS)
    end
  end

  def public_representation_present
    unless nickname.present? || emoji.present?
      errors.add(:nickname, :nickname_and_emoji_blank, message: "or Emoji must be provided (or you can specify both)")
    end
  end

  def strip_spaces
    self.name = name&.strip
    self.email = email&.strip
    self.emoji = emoji&.strip
  end

end
