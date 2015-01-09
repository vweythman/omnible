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

ActiveRecord::Schema.define(version: 20150106210320) do

  create_table "character_term", id: false, force: true do |t|
    t.integer "character_id"
    t.integer "term_id"
  end

  add_index "character_term", ["character_id"], name: "index_character_term_on_character_id"
  add_index "character_term", ["term_id"], name: "index_character_term_on_term_id"

  create_table "characters", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facets", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "opinions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "term_edges", force: true do |t|
    t.integer "broad_term_id"
    t.integer "narrow_term_id"
  end

  create_table "terms", force: true do |t|
    t.string   "name"
    t.integer  "facet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "terms", ["facet_id"], name: "index_terms_on_facet_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "works", force: true do |t|
    t.text     "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
