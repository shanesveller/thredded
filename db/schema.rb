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

ActiveRecord::Schema.define(:version => 20110723111305) do

  create_table "images", :force => true do |t|
    t.integer  "width"
    t.integer  "height"
    t.string   "orientation"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messageboards", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "theme"
    t.integer  "thread_count",       :default => 0
    t.string   "security",           :default => "public"
    t.string   "posting_permission", :default => "anonymous"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topics_count",       :default => 0
  end

  add_index "messageboards", ["name"], :name => "index_messageboards_on_name", :unique => true
  add_index "messageboards", ["thread_count"], :name => "index_messageboards_on_thread_count"

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_email"
    t.text     "content"
    t.string   "ip"
    t.string   "filter",     :default => "bbcode"
    t.string   "source",     :default => "web"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topic_id"
  end

  create_table "private_users", :force => true do |t|
    t.integer  "private_topic_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "level"
    t.integer  "user_id"
    t.integer  "messageboard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["messageboard_id"], :name => "index_roles_on_messageboard_id"
  add_index "roles", ["user_id"], :name => "index_roles_on_user_id"

  create_table "sites", :force => true do |t|
    t.integer "user_id"
    t.string  "domain"
  end

  create_table "topics", :force => true do |t|
    t.integer  "user_id"
    t.integer  "last_user_id"
    t.string   "title"
    t.integer  "post_count",      :default => 0
    t.string   "permission",      :default => "public"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "messageboard_id"
    t.string   "type"
  end

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
    t.integer  "topics_count",                        :default => 0
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
