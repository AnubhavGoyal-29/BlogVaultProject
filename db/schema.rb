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

ActiveRecord::Schema.define(version: 2022_02_09_073531) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "plugins", force: :cascade do |t|
    t.string "plugin_name"
    t.string "url_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "version"
  end

  create_table "site_data", force: :cascade do |t|
    t.string "cms_type"
    t.string "cms_version"
    t.string "js"
    t.string "cloudflare"
    t.string "login_url"
    t.string "hosting"
    t.string "plugins"
    t.string "themes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_nos", force: :cascade do |t|
    t.integer "status"
    t.integer "number_of_urls"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "site_data_id"
    t.integer "t_no"
    t.integer "url_id"
    t.index ["site_data_id"], name: "index_tests_on_site_data_id"
    t.index ["t_no", "url_id"], name: "index_tests_on_t_no_and_url_id", unique: true
    t.index ["url_id"], name: "index_tests_on_url_id"
  end

  create_table "tests_urls", id: false, force: :cascade do |t|
    t.integer "test_id"
    t.integer "url_id"
    t.index ["test_id"], name: "index_tests_urls_on_test_id"
    t.index ["url_id"], name: "index_tests_urls_on_url_id"
  end

  create_table "themes", force: :cascade do |t|
    t.string "theme_name"
    t.string "url_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "version"
  end

  create_table "urls", force: :cascade do |t|
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "test_id"
    t.index ["test_id"], name: "index_urls_on_test_id"
  end

end
