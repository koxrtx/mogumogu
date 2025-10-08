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

ActiveRecord::Schema[8.0].define(version: 2025_10_07_030551) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agreements", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "terms_version"
    t.datetime "agreed_at"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_agreements_on_user_id"
  end

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
    t.integer "status", default: 0, null: false
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

  create_table "spot_update_request_images", force: :cascade do |t|
    t.bigint "spot_update_request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "spot_image_id"
    t.index ["spot_image_id"], name: "index_spot_update_request_images_on_spot_image_id"
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
    t.boolean "child_chair", default: false
    t.boolean "tatami_seat", default: false
    t.boolean "child_tableware", default: false
    t.boolean "bring_baby_food", default: false
    t.boolean "stroller_ok", default: false
    t.boolean "child_menu", default: false
    t.boolean "parking", default: false
    t.boolean "other_facility", default: false
    t.string "opening_hours"
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
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "agreements", "users"
  add_foreign_key "spot_facilities", "facility_tags"
  add_foreign_key "spot_facilities", "spots"
  add_foreign_key "spot_update_request_images", "active_storage_attachments", column: "spot_image_id"
  add_foreign_key "spot_update_request_images", "spot_update_requests"
  add_foreign_key "spot_update_requests", "facility_tags"
  add_foreign_key "spot_update_requests", "spots"
  add_foreign_key "spot_update_requests", "users"
  add_foreign_key "spots", "users"
end
