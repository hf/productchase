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

ActiveRecord::Schema.define(version: 20140924101123) do

  create_table "products", force: true do |t|
    t.string   "link",         null: false
    t.string   "name",         null: false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "day_of_entry", null: false
  end

  add_index "products", ["day_of_entry"], name: "index_products_on_day_of_entry"
  add_index "products", ["link"], name: "index_products_on_link", unique: true
  add_index "products", ["user_id"], name: "index_products_on_user_id"

  create_table "users", force: true do |t|
    t.string   "encrypted_password",     default: "",                                                                                  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                                                                                   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   default: "",                                                                                  null: false
    t.string   "uid",                    default: "",                                                                                  null: false
    t.string   "provider",               default: "",                                                                                  null: false
    t.string   "twitter_username"
    t.string   "twitter_pic",            default: "https://abs.twimg.com/sticky/default_profile_images/default_profile_3_400x400.png", null: false
    t.string   "personal_title"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["twitter_username"], name: "index_users_on_twitter_username", unique: true
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
