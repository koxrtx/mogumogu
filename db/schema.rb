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

ActiveRecord::Schema[8.0].define(version: 2025_09_10_132923) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "facility_tags", force: :cascade do |t|
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inquiries", force: :cascade do |t|
    t.string "name", null: false
    t.string "mail", null: false
    t.string "inquiry_comment", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spot_facilities", force: :cascade do |t|
    t.bigint "spot_id", null: false
    t.bigint "facility_tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_tag_id"], name: "index_spot_facilities_on_facility_tag_id"
    t.index ["spot_id", "facility_tag_id"], name: "index_spot_facilities_on_spot_id_and_facility_tag_id", unique: true
    t.index ["spot_id"], name: "index_spot_facilities_on_spot_id"
  end

  create_table "spot_images", force: :cascade do |t|
    t.bigint "spot_id", null: false
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_spot_images_on_spot_id"
  end

  create_table "spot_update_request_images", force: :cascade do |t|
    t.bigint "spot_update_request_id", null: false
    t.bigint "spot_image_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_image_id"], name: "index_spot_update_request_images_on_spot_image_id"
    t.index ["spot_update_request_id", "spot_image_id"], name: "idx_on_spot_update_request_id_spot_image_id_8387f307d5", unique: true
    t.index ["spot_update_request_id"], name: "index_spot_update_request_images_on_spot_update_request_id"
  end

  create_table "spot_update_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "spot_id", null: false
    t.bigint "facility_tag_id"
    t.jsonb "request_data"
    t.integer "checkbox", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "photo_delete_reason", null: false
    t.index ["facility_tag_id"], name: "index_spot_update_requests_on_facility_tag_id"
    t.index ["spot_id"], name: "index_spot_update_requests_on_spot_id"
    t.index ["user_id"], name: "index_spot_update_requests_on_user_id"
  end

  create_table "spots", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", null: false
    t.string "address", null: false
    t.string "tel"
    t.text "other_facility_comment"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["address"], name: "index_spots_on_address"
    t.index ["user_id"], name: "index_spots_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "line_user_id"
    t.string "google_user_id"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "spot_facilities", "facility_tags"
  add_foreign_key "spot_facilities", "spots"
  add_foreign_key "spot_images", "spots"
  add_foreign_key "spot_update_request_images", "spot_images"
  add_foreign_key "spot_update_request_images", "spot_update_requests"
  add_foreign_key "spot_update_requests", "facility_tags"
  add_foreign_key "spot_update_requests", "spots"
  add_foreign_key "spot_update_requests", "users"
  add_foreign_key "spots", "users"
end
