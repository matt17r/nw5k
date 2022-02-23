class AllowNullResultTime < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:results, :time, true, ResultsHelper::MAXIMUM_TIME)
  end
end
