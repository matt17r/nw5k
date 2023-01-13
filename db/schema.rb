# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_01_13_071103) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "distances", ["5km", "2miles"]

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest", null: false
    t.string "remember_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email"
  end

  create_table "banners", force: :cascade do |t|
    t.string "title", null: false
    t.string "body"
    t.datetime "publish_at", null: false
    t.datetime "withdraw_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publish_at"], name: "index_banners_on_publish_at"
    t.index ["withdraw_at"], name: "index_banners_on_withdraw_at"
  end

  create_table "events", force: :cascade do |t|
    t.date "date", null: false
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_events_on_number", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "nickname"
    t.string "emoji"
    t.string "password_digest", null: false
    t.string "remember_token", null: false
    t.date "birthdate"
    t.string "country"
    t.string "parkrun_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_people_on_email"
    t.index ["nickname"], name: "index_people_on_nickname"
    t.index ["parkrun_id"], name: "index_people_on_parkrun_id"
    t.index ["remember_token"], name: "index_people_on_remember_token", unique: true
  end

  create_table "results", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "event_id", null: false
    t.integer "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "distance", default: "5km", null: false, enum_type: "distances"
    t.index ["event_id"], name: "index_results_on_event_id"
    t.index ["person_id"], name: "index_results_on_person_id"
  end

  create_table "volunteers", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "event_id", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_volunteers_on_event_id"
    t.index ["person_id"], name: "index_volunteers_on_person_id"
  end

  add_foreign_key "results", "events"
  add_foreign_key "results", "people"
  add_foreign_key "volunteers", "events"
  add_foreign_key "volunteers", "people"

  create_view "results_with_historical_data", materialized: true, sql_definition: <<-SQL
      SELECT results.id,
      results.event_id,
      events.date,
      results.distance,
      rank() OVER (PARTITION BY results.event_id, results.distance ORDER BY results."time") AS "position",
      results.person_id,
      results."time",
          CASE
              WHEN ((results.person_id IS NOT NULL) AND (events.date = min(events.date) OVER (PARTITION BY results.person_id ORDER BY events.date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))) THEN true
              ELSE NULL::boolean
          END AS first_timer,
      min(results."time") OVER (PARTITION BY results.person_id, results.distance ORDER BY events.date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS fastest_time_to_date
     FROM (results
       JOIN events ON ((results.event_id = events.id)))
    ORDER BY events.date;
  SQL
end
