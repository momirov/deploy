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

ActiveRecord::Schema.define(:version => 20121221124638) do

  create_table "deployments", :force => true do |t|
    t.integer  "stage_id"
    t.integer  "project_id"
    t.string   "user"
    t.text     "log"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "status"
    t.string   "old_revision"
    t.string   "new_revision"
    t.datetime "completed_at"
  end

  add_index "deployments", ["project_id"], :name => "index_deployments_on_project_id"
  add_index "deployments", ["stage_id"], :name => "index_deployments_on_stage_id"

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "repo"
  end

  create_table "stages", :force => true do |t|
    t.integer  "project_id"
    t.string   "title"
    t.string   "deploy_cmd"
    t.string   "current_version_cmd"
    t.string   "next_version_cmd"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "position"
    t.string   "rollback_cmd"
  end

  add_index "stages", ["project_id"], :name => "index_stages_on_project_id"

  create_table "users", :force => true do |t|
    t.string   "email",               :default => "", :null => false
    t.string   "encrypted_password",  :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "login",               :default => "", :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
