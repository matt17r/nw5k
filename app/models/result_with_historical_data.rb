class ResultWithHistoricalData < ApplicationRecord
  self.table_name = 'results_with_historical_data'

  belongs_to :person, optional: true
  belongs_to :event

  def readonly?
    true
  end

  def self.refresh
    Scenic.database.refresh_materialized_view(:results_with_historical_data, concurrently: false, cascade: false)
  end

  def pb?
    return false unless person
    return false if first_timer?
    time && time == fastest_time_to_date
  end

  def time_string
    return "Unknown" unless time
    format_string = (time < 3600 ? "%M:%S" : "%k:%M:%S")
    Time.at(time).utc.strftime(format_string).strip
  end
end
