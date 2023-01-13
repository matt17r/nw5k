class UpdateResultsWithHistoricalDataToVersion2 < ActiveRecord::Migration[7.0]
  def change

    update_view :results_with_historical_data, version: 2, revert_to_version: 1, materialized: true
  end
end
