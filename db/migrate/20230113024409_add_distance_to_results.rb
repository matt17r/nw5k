class AddDistanceToResults < ActiveRecord::Migration[7.0]
  def change
    create_enum :distances, ["5km", "2miles"]
    add_column :results, :distance, :enum, enum_type: "distances", default: "5km", null: false
  end
end
