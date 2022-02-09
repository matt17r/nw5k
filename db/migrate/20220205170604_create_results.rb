class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.references :person, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :time, null: false

      t.timestamps
    end
  end
end
