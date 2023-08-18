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

ActiveRecord::Schema.define(version: 20160924020650) do

  create_table "clients", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "contact"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", force: :cascade do |t|
    t.integer  "client_id"
    t.string   "name",       limit: 255
    t.text     "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manufacturing_jobs", force: :cascade do |t|
    t.integer  "phase_id"
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manufacturing_jobs_parts", id: false, force: :cascade do |t|
    t.integer "manufacturing_job_id"
    t.integer "part_id"
  end

  create_table "materials", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.decimal  "width"
    t.decimal  "height"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "material_type",  limit: 255
    t.decimal  "cut_spacing"
    t.text     "length_options"
  end

  create_table "nest_objects", force: :cascade do |t|
    t.integer  "part_id"
    t.integer  "nest_id"
    t.decimal  "x"
    t.decimal  "y"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "rotated"
  end

  create_table "nest_runs", force: :cascade do |t|
    t.integer  "manufacturing_job_id"
    t.integer  "material_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nests", force: :cascade do |t|
    t.integer  "nest_run_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_manufactured"
    t.decimal  "length"
    t.text     "svg"
    t.text     "map_svg"
  end

  create_table "panel_models", force: :cascade do |t|
    t.string   "name",                           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "panel_model_image_file_name",    limit: 255
    t.string   "panel_model_image_content_type", limit: 255
    t.integer  "panel_model_image_file_size"
    t.datetime "panel_model_image_updated_at"
  end

  create_table "panels", force: :cascade do |t|
    t.integer  "structure_id"
    t.integer  "panel_model_id"
    t.boolean  "is_manufactured"
    t.boolean  "is_assembled"
    t.integer  "side_position"
    t.decimal  "width"
    t.decimal  "height"
    t.boolean  "deflector"
    t.boolean  "buried"
    t.decimal  "door_width"
    t.decimal  "door_height"
    t.decimal  "door_inset_left"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "part_types", force: :cascade do |t|
    t.integer  "material_id"
    t.string   "name",                         limit: 255
    t.text     "description"
    t.string   "image",                        limit: 255
    t.integer  "version"
    t.boolean  "nestable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "part_type_image_file_name",    limit: 255
    t.string   "part_type_image_content_type", limit: 255
    t.integer  "part_type_image_file_size"
    t.datetime "part_type_image_updated_at"
  end

  create_table "parts", force: :cascade do |t|
    t.integer  "part_type_id"
    t.integer  "panel_id"
    t.decimal  "length"
    t.decimal  "width"
    t.decimal  "height"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_manufactured"
    t.text     "svg"
  end

  create_table "phases", force: :cascade do |t|
    t.integer  "job_id"
    t.string   "name",              limit: 255
    t.date     "manufacture_start"
    t.date     "manufacture_end"
    t.date     "install_start"
    t.date     "install_end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text     "message"
    t.string   "username",   limit: 255
    t.integer  "item"
    t.string   "table",      limit: 255
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories"

  create_table "structures", force: :cascade do |t|
    t.integer  "phase_id"
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",      limit: 255
    t.string   "password_hash", limit: 255
    t.string   "password_salt", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",          limit: 255
  end

end
