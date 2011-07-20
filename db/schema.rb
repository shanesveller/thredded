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

ActiveRecord::Schema.define(:version => 20110720021131) do

  create_table "messageboards", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "theme"
    t.integer  "thread_count",       :default => 0
    t.string   "security",           :default => "public"
    t.string   "posting_permission", :default => "anonymous"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messageboards", ["name"], :name => "index_messageboards_on_name", :unique => true
  add_index "messageboards", ["thread_count"], :name => "index_messageboards_on_thread_count"

  create_table "roles", :force => true do |t|
    t.string   "level"
    t.integer  "user_id"
    t.integer  "messageboard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["messageboard_id"], :name => "index_roles_on_messageboard_id"
  add_index "roles", ["user_id"], :name => "index_roles_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "name"
    t.boolean  "superadmin",                          :default => false, :null => false
    t.integer  "posts_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
