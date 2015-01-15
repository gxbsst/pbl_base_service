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

ActiveRecord::Schema.define(version: 20150115094508) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "hstore"

  create_table "assignments_scores", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "owner_id"
    t.integer  "score"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "user_id"
    t.string   "owner_type"
    t.uuid     "scorer_id"
  end

  add_index "assignments_scores", ["owner_id"], name: "index_assignments_scores_on_owner_id", using: :btree
  add_index "assignments_scores", ["owner_type"], name: "index_assignments_scores_on_owner_type", using: :btree
  add_index "assignments_scores", ["scorer_id"], name: "index_assignments_scores_on_scorer_id", using: :btree
  add_index "assignments_scores", ["user_id"], name: "index_assignments_scores_on_user_id", using: :btree

  create_table "assignments_works", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "sender_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "task_id"
    t.string   "task_type"
    t.string   "acceptor_type"
    t.uuid     "acceptor_id"
    t.text     "content"
    t.uuid     "resource_id"
    t.datetime "submit_at"
    t.uuid     "lock_by"
  end

  add_index "assignments_works", ["acceptor_id"], name: "index_assignments_works_on_acceptor_id", using: :btree
  add_index "assignments_works", ["acceptor_type"], name: "index_assignments_works_on_acceptor_type", using: :btree
  add_index "assignments_works", ["lock_by"], name: "index_assignments_works_on_lock_by", using: :btree
  add_index "assignments_works", ["sender_id"], name: "index_assignments_works_on_sender_id", using: :btree
  add_index "assignments_works", ["task_id", "task_type"], name: "index_assignments_works_on_task_id_and_task_type", using: :btree

  create_table "comments", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.string   "commentable_type"
    t.uuid     "commentable_id"
    t.uuid     "user_id"
    t.string   "role",                        default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "curriculums_phases", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.integer  "position"
    t.uuid     "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curriculums_standard_items", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "content"
    t.integer  "position"
    t.uuid     "standard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_category", default: false
  end

  create_table "curriculums_standards", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "title"
    t.integer  "position"
    t.uuid     "phase_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curriculums_subjects", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "user_id"
    t.uuid     "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["user_id", "follower_id"], name: "index_follows_on_user_id_and_follower_id", using: :btree

  create_table "friend_ships", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "user_id"
    t.uuid     "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gauges", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "level_1"
    t.string   "level_2"
    t.string   "level_3"
    t.string   "level_4"
    t.string   "level_5"
    t.string   "level_6"
    t.string   "level_7"
    t.uuid     "technique_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reference_count"
    t.string   "standard"
    t.string   "weight"
  end

  create_table "groups_groups", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "members_count", default: 0
    t.string   "owner_type"
    t.uuid     "owner_id"
  end

  add_index "groups_groups", ["owner_id", "owner_type"], name: "index_groups_groups_on_owner_id_and_owner_type", using: :btree

  create_table "groups_member_ships", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "user_id"
    t.uuid     "group_id"
    t.text     "role",       default: [], array: true
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups_member_ships", ["group_id", "user_id"], name: "index_groups_member_ships_on_group_id_and_user_id", using: :btree

  create_table "groups_posts", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "group_id"
    t.uuid     "user_id"
    t.string   "subject"
    t.text     "body"
    t.integer  "likes_count",      default: 0
    t.integer  "forwardeds_count", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups_posts", ["group_id"], name: "index_groups_posts_on_group_id", using: :btree
  add_index "groups_posts", ["user_id"], name: "index_groups_posts_on_user_id", using: :btree

  create_table "notifications", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "subject"
    t.text     "content"
    t.string   "sender_type"
    t.uuid     "sender_id"
    t.uuid     "user_id"
    t.hstore   "additional_info"
    t.boolean  "read",            default: true
    t.string   "state"
    t.boolean  "global",          default: false
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["sender_id"], name: "index_notifications_on_sender_id", using: :btree
  add_index "notifications", ["sender_type"], name: "index_notifications_on_sender_type", using: :btree
  add_index "notifications", ["type"], name: "index_notifications_on_type", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "pbls_disciplines", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pbls_discussion_members", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "user_id"
    t.uuid     "discussion_id"
    t.text     "role",          default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pbls_discussions", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.uuid     "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "no"
    t.text     "resource_ids", default: [], array: true
  end

  create_table "pbls_knowledges", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.text     "description"
    t.uuid     "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pbls_products", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.text     "description"
    t.boolean  "is_final"
    t.uuid     "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.uuid     "product_form_id"
  end

  create_table "pbls_project_techniques", force: true do |t|
    t.uuid     "project_id"
    t.uuid     "technique_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pbls_projects", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.string   "state"
    t.text     "description"
    t.text     "driven_issue"
    t.text     "standard_analysis"
    t.integer  "duration"
    t.boolean  "public",            default: false
    t.integer  "limitation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "user_id"
    t.string   "rule_head"
    t.string   "rule_template"
    t.string   "duration_unit"
    t.uuid     "region_id"
    t.integer  "grade"
    t.datetime "start_at"
  end

  create_table "pbls_rules", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "technique_id"
    t.uuid     "project_id"
    t.uuid     "gauge_id"
    t.string   "weight"
    t.string   "standard"
    t.string   "level_1"
    t.string   "level_2"
    t.string   "level_3"
    t.string   "level_4"
    t.string   "level_5"
    t.string   "level_6"
    t.string   "level_7"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pbls_standard_decompositions", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "role"
    t.string   "verb"
    t.string   "technique"
    t.string   "noun"
    t.string   "product_name"
    t.uuid     "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pbls_standard_items", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "project_id"
    t.uuid     "standard_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pbls_tasks", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "project_id"
    t.string   "title"
    t.text     "description"
    t.string   "teacher_tools"
    t.string   "student_tools"
    t.string   "task_type"
    t.uuid     "discipline_id"
    t.integer  "evaluation_duration"
    t.string   "evaluation_cycle"
    t.integer  "product_id"
    t.integer  "event_duration"
    t.string   "event_cycle"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "site"
    t.datetime "start_at"
    t.string   "submit_way"
    t.boolean  "final",               default: false
    t.text     "resource_ids",        default: [],    array: true
    t.text     "rule_ids",            default: [],    array: true
    t.text     "discussion_ids",      default: [],    array: true
    t.string   "state"
  end

  add_index "pbls_tasks", ["state"], name: "index_pbls_tasks_on_state", using: :btree

  create_table "pbls_techniques", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "project_id"
    t.uuid     "technique_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_forms", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "region_hierarchies", id: false, force: true do |t|
    t.uuid    "ancestor_id",   null: false
    t.uuid    "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "region_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "anc_desc_idx", unique: true, using: :btree
  add_index "region_hierarchies", ["descendant_id"], name: "desc_idx", using: :btree

  create_table "regions", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.uuid     "parent_id"
    t.string   "pinyin"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regions", ["parent_id", "pinyin"], name: "index_regions_on_parent_id_and_pinyin", using: :btree
  add_index "regions", ["type"], name: "index_regions_on_type", using: :btree

  create_table "resources", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.string   "owner_id"
    t.string   "owner_type"
    t.string   "size"
    t.string   "ext"
    t.string   "mime_type"
    t.string   "md5"
    t.string   "key"
    t.text     "exif"
    t.text     "image_info"
    t.string   "image_ave"
    t.string   "persistent_id"
    t.text     "avinfo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "user_id"
  end

  add_index "resources", ["owner_id", "owner_type", "md5"], name: "index_resources_on_owner_id_and_owner_type_and_md5", using: :btree
  add_index "resources", ["user_id"], name: "index_resources_on_user_id", using: :btree

  create_table "roles", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.uuid     "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "skills_categories", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills_sub_categories", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.uuid     "category_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills_techniques", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "title"
    t.integer  "position"
    t.uuid     "sub_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "age"
    t.integer  "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "email"
    t.string   "username"
    t.integer  "followings_count", default: 0
    t.integer  "followers_count",  default: 0
    t.integer  "friends_count",    default: 0
    t.string   "avatar"
    t.string   "type"
  end

  add_index "users", ["type"], name: "index_users_on_type", using: :btree

  create_table "users_roles", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "user_id"
    t.uuid     "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
