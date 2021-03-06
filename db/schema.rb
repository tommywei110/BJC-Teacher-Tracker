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

ActiveRecord::Schema.define(version: 2021_04_26_041607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "email_templates", force: :cascade do |t|
    t.text "body"
    t.string "path"
    t.string "locale"
    t.string "handler"
    t.boolean "partial"
    t.string "format"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "subject"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "website"
    t.float "lat"
    t.float "lng"
    t.integer "num_validated_teachers", default: 0
    t.integer "teachers_count", default: 0
    t.datetime "created_at", default: -> { "now()" }
    t.datetime "updated_at", default: -> { "now()" }
    t.integer "num_denied_teachers", default: 0
    t.index ["name", "city", "website"], name: "index_schools_on_name_city_and_website"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "snap"
    t.integer "school_id"
    t.datetime "created_at", default: -> { "now()" }
    t.datetime "updated_at", default: -> { "now()" }
    t.integer "status"
    t.string "more_info"
    t.boolean "admin", default: false
    t.string "encrypted_google_token"
    t.string "encrypted_google_token_iv"
    t.string "encrypted_google_refresh_token"
    t.string "encrypted_google_refresh_token_iv"
    t.string "personal_website"
    t.integer "education_level", default: -1
    t.string "application_status", default: "Pending"
    t.string "microsoft_token"
    t.string "microsoft_refresh_token"
    t.string "snap_token"
    t.string "snap_refresh_token"
    t.string "clever_token"
    t.string "clever_refresh_token"
    t.index ["email", "first_name"], name: "index_teachers_on_email_and_first_name"
    t.index ["email"], name: "index_teachers_on_email", unique: true
    t.index ["school_id"], name: "index_teachers_on_school_id"
    t.index ["snap"], name: "index_teachers_on_snap", unique: true, where: "((snap)::text <> ''::text)"
    t.index ["status"], name: "index_teachers_on_status"
  end

end
