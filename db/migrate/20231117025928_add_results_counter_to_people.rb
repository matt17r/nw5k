class AddResultsCounterToPeople < ActiveRecord::Migration[7.0]
  def change
    change_table :people do |t|
      t.integer :results_count, default: 0
    end

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<-SQL.squish
        UPDATE people
           SET results_count = (SELECT  count(1)
                                  FROM  results
                                  WHERE results.person_id = people.id)
    SQL
  end
end
