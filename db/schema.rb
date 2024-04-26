# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_04_25_184611) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "flyway_schema_history", primary_key: "installed_rank", id: :integer, default: nil, force: :cascade do |t|
    t.string "version", limit: 50
    t.string "description", limit: 200, null: false
    t.string "type", limit: 20, null: false
    t.string "script", limit: 1000, null: false
    t.integer "checksum"
    t.string "installed_by", limit: 100, null: false
    t.datetime "installed_on", precision: nil, default: -> { "now()" }, null: false
    t.integer "execution_time", null: false
    t.boolean "success", null: false
    t.index ["success"], name: "flyway_schema_history_s_idx"
  end

  create_table "groups", primary_key: "group_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "group_name", limit: 50, null: false
    t.string "user_id", limit: 36, null: false
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "passwords", primary_key: "password_id", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "password", limit: 256, null: false
    t.string "user_id", limit: 36, null: false
    t.uuid "group_id", null: false
    t.index ["group_id"], name: "index_passwords_on_groups_id"
  end

  create_table "users", primary_key: "user_id", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "email", limit: 255
    t.boolean "email_confirmed"
    t.string "fullname", limit: 255
    t.string "password", limit: 255
    t.string "username", limit: 255
    t.string "api_key", limit: 255
    t.datetime "created"
    t.boolean "exists"
    t.datetime "updated"
  end

  add_foreign_key "groups", "users", primary_key: "user_id", name: "user", on_delete: :cascade
  add_foreign_key "passwords", "groups", primary_key: "group_id", name: "group", on_delete: :cascade
  add_foreign_key "passwords", "users", primary_key: "user_id", name: "user", on_delete: :cascade
end
