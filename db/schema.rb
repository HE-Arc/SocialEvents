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

ActiveRecord::Schema.define(version: 20150220083440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_locations", force: true do |t|
    t.string   "id_facebook"
    t.string   "name"
    t.string   "city"
    t.string   "street"
    t.string   "zip"
    t.string   "canton"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "category"
    t.string   "cover"
    t.integer  "likes"
    t.string   "link"
    t.string   "phone"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "id_facebook"
    t.string   "title"
    t.string   "picture"
    t.string   "category"
    t.text     "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "user_id"
    t.integer  "event_location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_published",      default: true
  end

  add_index "events", ["event_location_id"], name: "index_events_on_event_location_id", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "id_facebook"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "city"
    t.date     "birthday"
    t.string   "gender"
    t.boolean  "is_fetching",            default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
