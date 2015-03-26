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

ActiveRecord::Schema.define(version: 20150309204656) do

  create_table "acts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "anthologies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appearances", force: true do |t|
    t.integer  "work_id"
    t.integer  "character_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appearances", ["character_id"], name: "index_appearances_on_character_id"
  add_index "appearances", ["work_id"], name: "index_appearances_on_work_id"

  create_table "casts", force: true do |t|
    t.string   "title"
    t.text     "about"
    t.integer  "work_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "chapters" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "characters", force: true do |t|
    t.string   "name"
    t.text     "about"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collections", force: true do |t|
    t.integer  "work_id"
    t.integer  "anthology_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collections", ["anthology_id"], name: "index_collections_on_anthology_id"
  add_index "collections", ["work_id"], name: "index_collections_on_work_id"

  create_table "conceptions", force: true do |t|
    t.integer  "work_id"
    t.integer  "concept_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conceptions", ["concept_id"], name: "index_conceptions_on_concept_id"
  add_index "conceptions", ["work_id"], name: "index_conceptions_on_work_id"

  create_table "concepts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "descriptions", force: true do |t|
    t.integer "character_id"
    t.integer "identity_id"
  end

  add_index "descriptions", ["character_id"], name: "index_descriptions_on_character_id"
  add_index "descriptions", ["identity_id"], name: "index_descriptions_on_identity_id"

  create_table "facets", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forms", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "generics", force: true do |t|
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

  create_table "identifiers", force: true do |t|
    t.string   "name"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identifiers", ["character_id"], name: "index_identifiers_on_character_id"

  create_table "identities", force: true do |t|
    t.string   "name"
    t.integer  "facet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.string   "name"
    t.integer  "generic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "name"
    t.integer  "form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["form_id"], name: "index_locations_on_form_id"

# Could not dump table "memberships" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "notes", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "work_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "relationships" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "relators", force: true do |t|
    t.string   "left_name"
    t.string   "right_name"
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

  create_table "viewpoints", force: true do |t|
    t.integer  "character_id"
    t.integer  "recip_id"
    t.string   "recip_type"
    t.integer  "warmth"
    t.integer  "respect"
    t.text     "about"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "viewpoints", ["character_id"], name: "index_opinions_on_character_id"

  create_table "works", force: true do |t|
    t.string   "title"
    t.text     "summary"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "works", ["user_id"], name: "index_works_on_user_id"

end
