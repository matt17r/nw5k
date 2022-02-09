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

ActiveRecord::Schema.define(version: 2022_02_05_170604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.date "date", null: false
    t.integer "number", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_people_on_email"
    t.index ["nickname"], name: "index_people_on_nickname"
    t.index ["parkrun_id"], name: "index_people_on_parkrun_id"
    t.index ["remember_token"], name: "index_people_on_remember_token", unique: true
  end

  create_table "results", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "event_id", null: false
    t.integer "time", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_results_on_event_id"
    t.index ["person_id"], name: "index_results_on_person_id"
  end

  add_foreign_key "results", "events"
  add_foreign_key "results", "people"
end
