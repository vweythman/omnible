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

ActiveRecord::Schema.define(version: 20160103172237) do

  create_table "activities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "adjectives", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "permission_level"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "admins", ["user_id"], name: "index_admins_on_user_id"

  create_table "anthologies", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "summary"
    t.integer  "uploader_id"
  end

  add_index "anthologies", ["uploader_id"], name: "index_anthologies_on_uploader_id"

  create_table "appearances", force: :cascade do |t|
    t.integer  "work_id"
    t.integer  "character_id"
    t.string   "role",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appearances", ["character_id"], name: "index_appearances_on_character_id"
  add_index "appearances", ["work_id"], name: "index_appearances_on_work_id"

  create_table "blocks", force: :cascade do |t|
    t.integer  "blocker_id"
    t.integer  "blocked_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "blocks", ["blocked_id"], name: "index_blocks_on_blocked_id"
  add_index "blocks", ["blocker_id"], name: "index_blocks_on_blocker_id"

  create_table "challenges", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.integer  "uploader_id"
    t.text     "about"
    t.string   "response_level", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "challenges", ["uploader_id"], name: "index_challenges_on_uploader_id"

  create_table "chapters", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "content"
    t.integer  "story_id"
    t.string   "about",      limit: 255
    t.string   "afterward",  limit: 255
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chapters", ["story_id"], name: "index_chapters_on_story_id"

  create_table "character_infos", force: :cascade do |t|
    t.string   "title"
    t.text     "content",      null: false
    t.integer  "character_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "character_infos", ["character_id"], name: "index_character_infos_on_character_id"

  create_table "characters", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "uploader_id"
    t.integer  "publicity_level"
    t.integer  "editor_level"
    t.boolean  "allow_play"
    t.boolean  "allow_clones"
    t.boolean  "allow_as_clone"
    t.boolean  "is_fictional",                default: true
    t.boolean  "can_connect",                 default: true
  end

  create_table "collections", force: :cascade do |t|
    t.integer  "work_id"
    t.integer  "anthology_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collections", ["anthology_id"], name: "index_collections_on_anthology_id"
  add_index "collections", ["work_id"], name: "index_collections_on_work_id"

  create_table "comments", force: :cascade do |t|
    t.integer  "topic_id",                               null: false
    t.integer  "creator_id",                             null: false
    t.string   "creator_type",   limit: 255,             null: false
    t.integer  "parent_id"
    t.integer  "lft",                                    null: false
    t.integer  "rgt",                                    null: false
    t.integer  "depth",                      default: 0, null: false
    t.integer  "children_count",             default: 0, null: false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["creator_id", "creator_type"], name: "index_comments_on_creator_id_and_creator_type"
  add_index "comments", ["topic_id"], name: "index_comments_on_topic_id"

  create_table "creator_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "agentive",   default: "by"
  end

  create_table "creator_categories_works_type_describers", id: false, force: :cascade do |t|
    t.integer "creator_category_id"
    t.integer "works_type_describer_id"
  end

  create_table "creatorships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "work_id"
    t.integer  "creator_category_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "creatorships", ["creator_category_id"], name: "index_creatorships_on_creator_category_id"
  add_index "creatorships", ["user_id"], name: "index_creatorships_on_user_id"
  add_index "creatorships", ["work_id"], name: "index_creatorships_on_work_id"

  create_table "descriptions", force: :cascade do |t|
    t.integer "character_id"
    t.integer "identity_id"
  end

  add_index "descriptions", ["character_id"], name: "index_descriptions_on_character_id"
  add_index "descriptions", ["identity_id"], name: "index_descriptions_on_identity_id"

  create_table "edit_invites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "editable_id"
    t.string   "editable_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "edit_invites", ["editable_type", "editable_id"], name: "index_invited_editors_on_editable_type_and_editable_id"
  add_index "edit_invites", ["user_id"], name: "index_invited_editors_on_user_id"

  create_table "events", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "uploader_id"
  end

  add_index "events", ["place_id"], name: "index_events_on_place_id"

  create_table "exchanges", force: :cascade do |t|
    t.integer  "uploader_id",                null: false
    t.text     "about"
    t.string   "response_level", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exchanges", ["uploader_id"], name: "index_exchanges_on_uploader_id"

  create_table "facets", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followings", force: :cascade do |t|
    t.integer  "follower_id", null: false
    t.integer  "followed_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "followings", ["followed_id"], name: "index_followings_on_followed_id"
  add_index "followings", ["follower_id"], name: "index_followings_on_follower_id"

  create_table "forms", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer  "friender_id",                 null: false
    t.integer  "friendee_id",                 null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "is_mutual",   default: false
  end

  add_index "friendships", ["friendee_id"], name: "index_friendships_on_friendee_id"
  add_index "friendships", ["friender_id"], name: "index_friendships_on_friender_id"

  create_table "generics", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "uploader_id"
  end

  create_table "hosts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "reference",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identifiers", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identifiers", ["character_id"], name: "index_identifiers_on_character_id"

  create_table "identities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "facet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["facet_id"], name: "index_identities_on_facet_id"

  create_table "interconnections", force: :cascade do |t|
    t.integer  "left_id"
    t.integer  "relator_id"
    t.integer  "right_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interconnections", ["left_id"], name: "index_interconnections_on_left_id"
  add_index "interconnections", ["relator_id"], name: "index_interconnections_on_relator_id"
  add_index "interconnections", ["right_id"], name: "index_interconnections_on_right_id"

  create_table "item_tags", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "quality_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_tags", ["item_id"], name: "index_item_descriptions_on_item_id"
  add_index "item_tags", ["quality_id"], name: "index_item_descriptions_on_quality_id"

  create_table "items", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.integer  "generic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",        limit: 255
    t.integer  "uploader_id"
  end

  add_index "items", ["generic_id"], name: "index_items_on_generic_id"
  add_index "items", ["uploader_id"], name: "index_items_on_uploader_id"

  create_table "localities", force: :cascade do |t|
    t.integer  "domain_id"
    t.integer  "subdomain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "localities", ["domain_id"], name: "index_localities_on_domain_id"
  add_index "localities", ["subdomain_id"], name: "index_localities_on_subdomain_id"

  create_table "locations", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "place_id"
    t.string   "nature",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["character_id"], name: "index_locations_on_character_id"
  add_index "locations", ["place_id"], name: "index_locations_on_place_id"

  create_table "memberships", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "character_id"
    t.string   "role",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["character_id"], name: "index_memberships_on_character_id"
  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id"

  create_table "notes", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "content"
    t.integer  "work_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["work_id"], name: "index_notes_on_work_id"

  create_table "opinions", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "recip_id"
    t.integer  "fondness",     null: false
    t.integer  "respect",      null: false
    t.text     "about"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "opinions", ["character_id"], name: "index_opinions_on_character_id"
  add_index "opinions", ["recip_id"], name: "index_opinions_on_recip_id"

  create_table "pitches", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "about"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pitches", ["user_id"], name: "index_pitches_on_user_id"

  create_table "places", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "fictional",                   null: false
    t.integer  "editor_level"
    t.integer  "publicity_level"
    t.integer  "uploader_id"
  end

  add_index "places", ["form_id"], name: "index_places_on_form_id"

  create_table "possessions", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nature",       limit: 255
  end

  add_index "possessions", ["character_id"], name: "index_possessions_on_character_id"
  add_index "possessions", ["item_id"], name: "index_possessions_on_item_id"

  create_table "prejudices", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "identity_id"
    t.integer  "fondness"
    t.integer  "respect"
    t.text     "about"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prejudices", ["character_id"], name: "index_prejudices_on_character_id"
  add_index "prejudices", ["identity_id"], name: "index_prejudices_on_identity_id"

  create_table "pseudonymings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "character_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "type"
    t.boolean  "is_primary",   default: false
  end

  add_index "pseudonymings", ["character_id"], name: "index_pseudonymings_on_character_id"
  add_index "pseudonymings", ["user_id"], name: "index_pseudonymings_on_user_id"

  create_table "qualities", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "slug",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "adjective_id",             default: 0, null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "work_id"
    t.integer  "violence"
    t.integer  "sexuality"
    t.integer  "language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["work_id"], name: "index_ratings_on_work_id"

  create_table "relators", force: :cascade do |t|
    t.string   "left_name",  limit: 255
    t.string   "right_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replications", force: :cascade do |t|
    t.integer  "original_id"
    t.integer  "clone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "replications", ["clone_id"], name: "index_replications_on_clone_id"
  add_index "replications", ["original_id"], name: "index_replications_on_original_id"

  create_table "respondences", force: :cascade do |t|
    t.integer  "caller_id"
    t.string   "caller_type", limit: 255
    t.integer  "response_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "respondences", ["caller_id", "caller_type"], name: "index_challenge_responses_on_caller_id_and_caller_type"
  add_index "respondences", ["response_id"], name: "index_challenge_responses_on_response_id_and_response_type"

  create_table "reviews", force: :cascade do |t|
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

  create_table "settings", force: :cascade do |t|
    t.integer  "work_id",    null: false
    t.integer  "place_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["place_id"], name: "index_settings_on_place_id"
  add_index "settings", ["work_id"], name: "index_settings_on_work_id"

  create_table "skinnings", force: :cascade do |t|
    t.integer  "work_id"
    t.integer  "skin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "skinnings", ["skin_id"], name: "index_skinnings_on_skin_id"
  add_index "skinnings", ["work_id"], name: "index_skinnings_on_work_id"

  create_table "skins", force: :cascade do |t|
    t.integer  "uploader_id"
    t.text     "style"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "title"
    t.string   "status",      default: "unpublished"
  end

  add_index "skins", ["uploader_id"], name: "index_skins_on_uploader_id"

  create_table "sources", force: :cascade do |t|
    t.string   "reference",       limit: 255
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "referencer_id"
    t.string   "referencer_type"
  end

  add_index "sources", ["host_id"], name: "index_sources_on_host_id"
  add_index "sources", ["referencer_type", "referencer_id"], name: "index_sources_on_referencer_type_and_referencer_id"

  create_table "taggings", force: :cascade do |t|
    t.integer  "work_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id"
  add_index "taggings", ["work_id"], name: "index_taggings_on_work_id"

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "slug",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.integer  "creator_id"
    t.string   "creator_type",   limit: 255
    t.boolean  "allow_response",             default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "discussed_id"
    t.string   "discussed_type", limit: 255
  end

  add_index "topics", ["creator_id", "creator_type"], name: "index_topics_on_creator_id_and_creator_type"
  add_index "topics", ["discussed_id", "discussed_type"], name: "index_topics_on_discussed_id_and_discussed_type"

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "view_invites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "view_invites", ["user_id"], name: "index_view_invites_on_user_id"
  add_index "view_invites", ["viewable_type", "viewable_id"], name: "index_view_invites_on_viewable_type_and_viewable_id"

  create_table "works", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.text     "summary"
    t.integer  "uploader_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "publicity_level"
    t.boolean  "is_complete",                 default: false
    t.integer  "editor_level"
    t.string   "type"
  end

  add_index "works", ["uploader_id"], name: "index_works_on_uploader_id"

  create_table "works_type_describers", force: :cascade do |t|
    t.string   "name",                                   null: false
    t.boolean  "is_narrative",           default: true,  null: false
    t.boolean  "is_singleton",           default: true,  null: false
    t.string   "content_type",           default: "t",   null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "is_record",              default: false, null: false
    t.boolean  "is_creative_expression", default: true,  null: false
  end

end
