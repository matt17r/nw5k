class CreateVolunteers < ActiveRecord::Migration[7.0]
  def change
    create_table :volunteers do |t|
      t.references :person, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
