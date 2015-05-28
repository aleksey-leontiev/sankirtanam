# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150528085645) do

  create_table "locations", force: true do |t|
    t.string "name"
    t.string "url"
  end

  create_table "people", force: true do |t|
    t.string  "name"
    t.integer "location_id"
  end

  add_index "people", ["location_id"], name: "index_people_on_location_id"

  create_table "statistic_record_details", force: true do |t|
    t.integer "statistic_record_id"
    t.integer "d01"
    t.integer "d02"
    t.integer "d03"
    t.integer "d04"
    t.integer "d05"
    t.integer "d06"
    t.integer "d07"
    t.integer "d08"
    t.integer "d09"
    t.integer "d10"
    t.integer "d11"
    t.integer "d12"
    t.integer "d13"
    t.integer "d14"
    t.integer "d15"
    t.integer "d16"
    t.integer "d17"
    t.integer "d18"
    t.integer "d19"
    t.integer "d20"
    t.integer "d21"
    t.integer "d22"
    t.integer "d23"
    t.integer "d24"
    t.integer "d25"
    t.integer "d26"
    t.integer "d27"
    t.integer "d28"
    t.integer "d29"
    t.integer "d30"
    t.integer "d31"
    t.integer "quantity"
    t.decimal "scores"
  end

  add_index "statistic_record_details", ["statistic_record_id"], name: "index_statistic_record_details_on_statistic_record_id"

  create_table "statistic_records", force: true do |t|
    t.integer "statistic_report_id"
    t.integer "person_id"
    t.integer "huge"
    t.integer "big"
    t.integer "medium"
    t.integer "small"
  end

  add_index "statistic_records", ["person_id"], name: "index_statistic_records_on_person_id"
  add_index "statistic_records", ["statistic_report_id"], name: "index_statistic_records_on_statistic_report_id"

  create_table "statistic_reports", force: true do |t|
    t.integer "location_id"
    t.date    "date"
  end

  add_index "statistic_reports", ["location_id"], name: "index_statistic_reports_on_location_id"

  create_table "user_location_accesses", force: true do |t|
    t.integer "user_id"
    t.integer "location_id"
  end

  add_index "user_location_accesses", ["location_id"], name: "index_user_location_accesses_on_location_id"
  add_index "user_location_accesses", ["user_id"], name: "index_user_location_accesses_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
