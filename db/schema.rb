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

ActiveRecord::Schema.define(version: 20130729143818) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "uid"
    t.string   "activity_id"
    t.string   "activity_description"
    t.datetime "activity_updated_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "charities", force: true do |t|
    t.string   "name"
    t.integer  "registered_number"
    t.text     "activities"
    t.string   "image"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.integer  "user_id"
    t.integer  "bill_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "charity"
  end

  create_table "subscriptions", force: true do |t|
    t.string   "create"
    t.string   "show"
    t.string   "index"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "stripe_customer_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fb_access_token"
    t.string   "fb_access_expires_at"
    t.integer  "charity_id"
  end

end
