module ResultsHelper
  MAXIMUM_TIME = (2.hours.to_i - 1).freeze
  MINIMUM_TIME = 755.freeze # 5000m world record on a track

  def time_as_string(time)
    return "Unknown" unless time
    format_string = (time < 3600 ? "%M:%S" : "%H:%M:%S")
    Time.at(time).utc.strftime(format_string)
  end
end
