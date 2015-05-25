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

ActiveRecord::Schema.define(version: 20150522221859) do

  create_table "activities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "adjectives", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "anthologies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "summary"
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

  create_table "chapters", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "work_id"
    t.string   "about"
    t.string   "afterward"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chapters", ["work_id"], name: "index_chapters_on_work_id"

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
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "connections", force: true do |t|
    t.integer  "left_id"
    t.integer  "relator_id"
    t.integer  "right_id"
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
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hosts", force: true do |t|
    t.string   "name"
    t.string   "reference"
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

  create_table "item_descriptions", force: true do |t|
    t.integer  "item_id"
    t.integer  "quality_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_descriptions", ["item_id"], name: "index_item_descriptions_on_item_id"
  add_index "item_descriptions", ["quality_id"], name: "index_item_descriptions_on_quality_id"

  create_table "items", force: true do |t|
    t.string   "name",       null: false
    t.integer  "generic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "memberships", force: true do |t|
    t.integer  "group_id"
    t.integer  "character_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["character_id"], name: "index_memberships_on_character_id"
  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id"

  create_table "notes", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "work_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pitches", force: true do |t|
    t.string   "title"
    t.text     "about"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pitches", ["user_id"], name: "index_pitches_on_user_id"

  create_table "places", force: true do |t|
    t.string   "name"
    t.integer  "form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "places", ["form_id"], name: "index_locations_on_form_id"

  create_table "possessions", force: true do |t|
    t.integer  "character_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "possessions", ["character_id"], name: "index_possessions_on_character_id"
  add_index "possessions", ["item_id"], name: "index_possessions_on_item_id"

  create_table "qualities", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "adjective_id", default: 0, null: false
  end

  create_table "ratings", force: true do |t|
    t.integer  "work_id"
    t.integer  "violence"
    t.integer  "sexuality"
    t.integer  "language"
    t.integer  "overall"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["work_id"], name: "index_ratings_on_work_id"

  create_table "relators", force: true do |t|
    t.string   "left_name"
    t.string   "right_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replications", force: true do |t|
    t.integer  "original_id"
    t.integer  "clone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "replications", ["clone_id"], name: "index_replications_on_clone_id"
  add_index "replications", ["original_id"], name: "index_replications_on_original_id"

  create_table "respondences", force: true do |t|
    t.integer  "caller_id"
    t.string   "caller_type"
    t.integer  "response_id"
    t.string   "response_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "respondences", ["caller_id", "caller_type"], name: "index_challenge_responses_on_caller_id_and_caller_type"
  add_index "respondences", ["response_id", "response_type"], name: "index_challenge_responses_on_response_id_and_response_type"

  create_table "reviews", force: true do |t|
    t.integer  "work_id"
    t.integer  "user_id"
    t.integer  "plot"
    t.integer  "characterization"
    t.integer  "writing"
    t.integer  "overall"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id"
  add_index "reviews", ["work_id"], name: "index_reviews_on_work_id"

  create_table "sources", force: true do |t|
    t.string   "reference"
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sources", ["host_id"], name: "index_sources_on_host_id"

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
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

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

  create_table "work_tags", force: true do |t|
    t.integer  "work_id"
    t.integer  "tag_id"
    t.string   "tag_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "work_tags", ["tag_id", "tag_type"], name: "index_work_tags_on_tag_id_and_tag_type"
  add_index "work_tags", ["work_id"], name: "index_work_tags_on_work_id"

  create_table "works", force: true do |t|
    t.string   "title"
    t.text     "summary"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "works", ["user_id"], name: "index_works_on_user_id"

end
