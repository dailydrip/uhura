# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_12_215905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string "auth_token"
    t.bigint "manager_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["auth_token"], name: "index_api_keys_on_auth_token", unique: true
    t.index ["manager_id"], name: "index_api_keys_on_manager_id"
  end

  create_table "clearstream_msgs", force: :cascade do |t|
    t.datetime "sent_to_clearstream"
    t.json "sms_json"
    t.datetime "got_response_at"
    t.text "clearstream_response"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "event_types", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_event_types_on_name", unique: true
  end

  create_table "managers", force: :cascade do |t|
    t.string "name"
    t.string "public_token"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_managers_on_email"
    t.index ["name"], name: "index_managers_on_name", unique: true
    t.index ["public_token"], name: "index_managers_on_public_token", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "sendgrid_msg_id"
    t.bigint "clearstream_msg_id"
    t.bigint "manager_id", null: false
    t.bigint "receiver_id", null: false
    t.bigint "team_id", null: false
    t.string "email_subject"
    t.text "email_message"
    t.bigint "template_id", null: false
    t.text "sms_message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["clearstream_msg_id"], name: "index_messages_on_clearstream_msg_id"
    t.index ["manager_id"], name: "index_messages_on_manager_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sendgrid_msg_id"], name: "index_messages_on_sendgrid_msg_id"
    t.index ["team_id"], name: "index_messages_on_team_id"
    t.index ["template_id"], name: "index_messages_on_template_id"
  end

  create_table "receivers", force: :cascade do |t|
    t.string "receiver"
    t.string "email"
    t.string "mobile_number"
    t.string "first_name"
    t.string "last_name"
    t.json "preferences"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_receivers_on_email", unique: true
    t.index ["receiver"], name: "index_receivers_on_receiver", unique: true
  end

  create_table "sendgrid_msgs", force: :cascade do |t|
    t.datetime "sent_to_sendgrid"
    t.json "mail_json"
    t.datetime "got_response_at"
    t.text "sendgrid_response"
    t.datetime "read_by_user_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.json "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_sources_on_name", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "x_team_id"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_teams_on_email"
    t.index ["name"], name: "index_teams_on_name", unique: true
    t.index ["x_team_id"], name: "index_teams_on_x_team_id", unique: true
  end

  create_table "templates", force: :cascade do |t|
    t.string "name"
    t.string "template_id"
    t.json "sample_template_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_templates_on_name", unique: true
  end

  create_table "ulogs", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "event_type_id", null: false
    t.text "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_type_id"], name: "index_ulogs_on_event_type_id"
    t.index ["source_id"], name: "index_ulogs_on_source_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.integer "household_id"
    t.string "token"
    t.string "secret"
    t.string "url"
    t.string "type"
    t.json "data"
    t.string "slug"
    t.string "last_sign_in_ip"
    t.datetime "last_sign_in_at"
    t.boolean "admin", default: false
    t.boolean "superadmin", default: false
    t.boolean "editor", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "api_keys", "managers"
  add_foreign_key "messages", "clearstream_msgs"
  add_foreign_key "messages", "managers"
  add_foreign_key "messages", "receivers"
  add_foreign_key "messages", "sendgrid_msgs"
  add_foreign_key "messages", "teams"
  add_foreign_key "messages", "templates"
  add_foreign_key "ulogs", "event_types"
  add_foreign_key "ulogs", "sources"
end
