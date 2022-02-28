module ResultsHelper
  MAXIMUM_TIME = 7200.freeze # 2 hours
  MINIMUM_TIME = 755.freeze # 5000m world record on a track

  MAXIMUM_TIME_STRING = Time.at(MAXIMUM_TIME).utc.strftime("%k:%M:%S").freeze
  MINIMUM_TIME_STRING = Time.at(MINIMUM_TIME).utc.strftime("%M:%S").freeze
end
