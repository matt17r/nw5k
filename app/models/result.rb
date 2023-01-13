class Result < ApplicationRecord
  HOUR_MINUTES_SECONDS_REGEXP = /\A(?:(?<hours>[0-9]?[0-9]):)?(?<minutes>[0-5]?[0-9]):(?<seconds>[0-5]?[0-9])\z/
  belongs_to :person, optional: true
  belongs_to :event

  enum distance: { '5km': "5km", '2miles': "2miles" }, _prefix: true

  validates :time, numericality: {
    only_integer: true,
    greater_than: ResultsHelper::MINIMUM_TIME,
    less_than: ResultsHelper::MAXIMUM_TIME,
    allow_nil: true
  }

  validate :validate_no_setter_errors

  def place
    event.results.where("time < ?", time).count + 1
  end

  def pb?
    return false unless person
    return false if first_timer?
    previous_best = person.results.joins(:event).where("events.number < ?", event.number).order(:time).first&.time
    time && (previous_best && time < previous_best) || time && !previous_best
  end

  def first_timer?
    return false unless person
    first_result = person.results.joins(:event).order(number: :asc).first
    self === first_result
  end

  def time_string
    return "Unknown" unless time
    format_string = (time < 3600 ? "%M:%S" : "%k:%M:%S")
    Time.at(time).utc.strftime(format_string).strip
  end

  def time_string=(input)
    if input.blank? || input == "Unknown"
      self.time = nil
      return
    end
    matches = HOUR_MINUTES_SECONDS_REGEXP.match(input.strip)
    raise ArgumentError if matches.nil?
    seconds = matches[:hours].to_i * 3600 + matches[:minutes].to_i * 60 + matches[:seconds].to_i
    raise ArgumentError if seconds <= ResultsHelper::MINIMUM_TIME || seconds >= ResultsHelper::MAXIMUM_TIME
    self.time = seconds
  rescue
    @setter_errors ||= {}
    @setter_errors[:time_string] ||= []
    @setter_errors[:time_string] << "must be a valid time greater than #{ResultsHelper::MINIMUM_TIME_STRING} and less than #{ResultsHelper::MAXIMUM_TIME_STRING}"
  end

  private

  def validate_no_setter_errors
    return true if !@setter_errors || @setter_errors.empty?
    @setter_errors.each do |attribute, messages|
      messages.each do |message|
        errors.add(attribute, message)
      end
    end
  end
end
