class CreateResultsWithHistoricalData < ActiveRecord::Migration[7.0]
  def change
    create_view :results_with_historical_data, materialized: true
  end
end
