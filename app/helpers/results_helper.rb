module ResultsHelper
  def time_as_string(time)
    return "Unknown" unless time
    format_string = (time < 3600 ? "%M:%S" : "%H:%M:%S")
    Time.at(time).utc.strftime(format_string)
  end
end
