class ConvertResultsWithHistoricalDataToRegularView < ActiveRecord::Migration[8.1]
  def up
    drop_view :results_with_historical_data, materialized: true
    create_view :results_with_historical_data, version: 3
  end

  def down
    drop_view :results_with_historical_data
    create_view :results_with_historical_data, version: 2, materialized: true
  end
end
