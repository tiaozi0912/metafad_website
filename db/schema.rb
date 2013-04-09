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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121005064958) do

  create_table "apn_devices", :force => true do |t|
    t.string   "token",              :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.datetime "last_registered_at"
    t.integer  "app_id"
    t.integer  "user_id"
  end

  add_index "apn_devices", ["token"], :name => "index_apn_devices_on_token", :unique => true
  add_index "apn_devices", ["user_id"], :name => "index_apn_devices_on_user_id"

  create_table "apn_notifications", :force => true do |t|
    t.integer  "device_id"
    t.integer  "errors_nb",         :default => 0
    t.string   "device_language"
    t.string   "sound"
    t.string   "alert"
    t.integer  "badge"
    t.text     "custom_properties"
    t.datetime "sent_at"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "is_read",           :default => false
    t.integer  "notification_type"
    t.integer  "item_id"
    t.integer  "action_user_id"
    t.integer  "user_id"
  end

  add_index "apn_notifications", ["device_id"], :name => "index_apn_notifications_on_device_id"

  create_table "audiences", :force => true do |t|
    t.integer  "poll_id"
    t.integer  "user_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "is_following", :default => false
    t.integer  "has_voted",    :default => 0
  end

  create_table "comments", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "item_id"
    t.integer  "commenter_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "event_type"
    t.integer  "user_id"
    t.integer  "poll_id"
    t.integer  "item_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.float    "rank",       :default => 0.0
    t.boolean  "is_deleted", :default => false
    t.float    "feed_rank"
  end

  create_table "flags", :force => true do |t|
    t.integer  "reporter_id"
    t.integer  "item_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "items", :force => true do |t|
    t.integer  "poll_id"
    t.string   "description"
    t.float    "price"
    t.integer  "number_of_votes",    :default => 0
    t.string   "photo_url"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "is_deleted",         :default => false
    t.string   "brand"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "number_of_flags",    :default => 0
  end

  create_table "messages", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "poll_records", :force => true do |t|
    t.integer  "poll_id"
    t.integer  "user_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "is_deleted",       :default => false
    t.integer  "poll_record_type"
  end

  create_table "polls", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "total_votes",               :default => 0
    t.integer  "max_votes_for_single_item"
    t.string   "end_time"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.boolean  "is_deleted",                :default => false
    t.integer  "category"
    t.integer  "state",                     :default => 0
    t.string   "open_time"
    t.integer  "number_of_sharing",         :default => 0
    t.integer  "accepted_item_id"
    t.integer  "poll_rewards_tracker",      :default => 0
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "rewards", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shared_polls", :force => true do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "user_name",                                :null => false
    t.string   "email",                                    :null => false
    t.string   "crypted_password",                         :null => false
    t.string   "password_salt",                            :null => false
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",           :default => 0,     :null => false
    t.integer  "failed_login_count",    :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "fb_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "number_of_flags",       :default => 0
    t.boolean  "has_profile_photo_url", :default => false
    t.boolean  "admin",                 :default => false
    t.integer  "point",                 :default => 0
    t.integer  "number_of_votes",       :default => 0
    t.integer  "votes_rewards_tracker", :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["user_name"], :name => "index_users_on_user_name"

end
