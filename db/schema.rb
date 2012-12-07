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

ActiveRecord::Schema.define(:version => 20121207082242) do

  create_table "assets", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "data_processing"
    t.datetime "data_updated_at"
    t.string   "position"
    t.string   "section"
    t.string   "place"
  end

  add_index "assets", ["attachable_id", "attachable_type"], :name => "index_assets_on_attachable_id_and_attachable_type"

  create_table "brands", :force => true do |t|
    t.string  "name",    :null => false
    t.boolean "popular"
  end

  create_table "cars", :force => true do |t|
    t.string   "brand"
    t.string   "model"
    t.integer  "year"
    t.string   "vin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "address"
    t.integer  "phone",      :limit => 8
    t.string   "site"
  end

  create_table "defects", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "report_id"
    t.string   "category"
    t.string   "sub_category"
    t.string   "defect_type"
    t.string   "size"
    t.string   "images"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "feedbacks", :force => true do |t|
    t.text     "text"
    t.string   "author"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "links", :force => true do |t|
    t.text     "url"
    t.integer  "report_id"
    t.string   "site"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "models", :force => true do |t|
    t.integer "brand_id"
    t.string  "name",     :null => false
    t.boolean "popular"
  end

  create_table "points", :force => true do |t|
    t.string   "object"
    t.integer  "report_id"
    t.string   "section"
    t.string   "place"
    t.string   "condition"
    t.string   "state"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "images"
    t.string   "description"
  end

  add_index "points", ["report_id"], :name => "index_points_on_report_id"

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.string   "org"
    t.integer  "phone",      :limit => 8
    t.integer  "user_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "reports", :force => true do |t|
    t.integer  "car_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "exterior"
    t.text     "wheels"
    t.text     "interior"
    t.text     "under_the_hood"
    t.text     "photo_others"
    t.text     "car"
    t.text     "documents"
    t.integer  "user_id"
    t.integer  "model_id"
    t.boolean  "publish",               :default => false
    t.text     "testdrive_description"
    t.integer  "company_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gallery_key"
    t.integer  "company_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
