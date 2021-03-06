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

ActiveRecord::Schema.define(version: 20150617045533) do

  create_table "deployments", force: :cascade do |t|
    t.integer  "stage_id"
    t.integer  "project_id"
    t.string   "user",         limit: 255
    t.text     "log"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",       limit: 255
    t.string   "old_revision", limit: 255
    t.string   "new_revision", limit: 255
    t.datetime "completed_at"
  end

  add_index "deployments", ["project_id"], name: "index_deployments_on_project_id"
  add_index "deployments", ["stage_id"], name: "index_deployments_on_stage_id"

  create_table "projects", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "repo",       limit: 255
  end

  create_table "ssh_keys", force: :cascade do |t|
    t.text     "private_key"
    t.text     "public_key"
    t.string   "comment",     limit: 255
    t.string   "passphrase",  limit: 255
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stages", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "title",               limit: 255
    t.string   "deploy_cmd",          limit: 255
    t.string   "current_version_cmd", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "rollback_cmd",        limit: 255
    t.string   "branch"
    t.boolean  "npm_support"
  end

  add_index "stages", ["project_id"], name: "index_stages_on_project_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",               limit: 255, default: "", null: false
    t.string   "encrypted_password",  limit: 255, default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",  limit: 255
    t.string   "last_sign_in_ip",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login",               limit: 255, default: "", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
