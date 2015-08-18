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

ActiveRecord::Schema.define(version: 20150826021028) do

  create_table "basechurch_announcements", force: true do |t|
    t.integer  "post_id"
    t.integer  "bulletin_id"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  add_index "basechurch_announcements", ["bulletin_id"], name: "index_basechurch_announcements_on_bulletin_id"
  add_index "basechurch_announcements", ["post_id"], name: "index_basechurch_announcements_on_post_id"

  create_table "basechurch_api_keys", force: true do |t|
    t.integer  "user_id"
    t.string   "access_token"
    t.string   "scope"
    t.datetime "expired_at"
    t.datetime "created_at"
  end

  add_index "basechurch_api_keys", ["access_token"], name: "index_basechurch_api_keys_on_access_token", unique: true
  add_index "basechurch_api_keys", ["user_id"], name: "index_basechurch_api_keys_on_user_id"

  create_table "basechurch_attachments", force: true do |t|
    t.string   "key"
    t.string   "url"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "basechurch_attachments", ["attachable_id", "attachable_type"], name: "attachments_polymorphic_keys_index"

  create_table "basechurch_bulletins", force: true do |t|
    t.datetime "published_at"
    t.string   "name"
    t.string   "description"
    t.text     "service_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.text     "sermon_notes"
  end

  create_table "basechurch_groups", force: true do |t|
    t.string   "name"
    t.string   "banner"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.text     "about"
  end

  add_index "basechurch_groups", ["slug"], name: "index_basechurch_groups_on_slug", unique: true

  create_table "basechurch_posts", force: true do |t|
    t.integer  "group_id"
    t.integer  "author_id"
    t.integer  "editor_id"
    t.string   "slug"
    t.string   "title"
    t.text     "content"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "basechurch_posts", ["author_id"], name: "index_basechurch_posts_on_author_id"
  add_index "basechurch_posts", ["editor_id"], name: "index_basechurch_posts_on_editor_id"
  add_index "basechurch_posts", ["group_id"], name: "index_basechurch_posts_on_group_id"

  create_table "basechurch_users", force: true do |t|
    t.string   "email"
    t.string   "name"
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

  add_index "basechurch_users", ["email"], name: "index_basechurch_users_on_email", unique: true
  add_index "basechurch_users", ["reset_password_token"], name: "index_basechurch_users_on_reset_password_token", unique: true

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

end
