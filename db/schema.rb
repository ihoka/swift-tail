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

ActiveRecord::Schema[8.0].define(version: 2025_07_26_153416) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "airports", force: :cascade do |t|
    t.string "iata_code", limit: 3
    t.string "icao_code", limit: 10
    t.string "name", null: false
    t.string "city"
    t.string "country"
    t.string "country_code", limit: 2
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "elevation_ft"
    t.string "type"
    t.boolean "private_jet_capable", default: false
    t.string "timezone"
    t.text "runways_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iata_code"], name: "index_airports_on_iata_code"
    t.index ["icao_code"], name: "index_airports_on_icao_code"
    t.index ["latitude", "longitude"], name: "index_airports_on_latitude_and_longitude"
    t.index ["private_jet_capable"], name: "index_airports_on_private_jet_capable"
  end

  create_table "leads", force: :cascade do |t|
    t.string "from"
    t.string "to"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end
end
