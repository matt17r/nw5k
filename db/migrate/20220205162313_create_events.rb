class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.date :date, null: false
      t.integer :number, null: false

      t.timestamps
    end
    add_index :events, :number, unique: true
  end
end
