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

ActiveRecord::Schema.define(version: 2022_12_31_005217) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
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
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "guest_id", null: false
    t.integer "host_id", null: false
    t.integer "reservation_id", null: false
    t.string "action", default: "", null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["guest_id"], name: "index_notifications_on_guest_id"
    t.index ["host_id"], name: "index_notifications_on_host_id"
    t.index ["reservation_id"], name: "index_notifications_on_reservation_id"
  end

  create_table "prices", force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "value", null: false
    t.integer "range", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_prices_on_room_id"
  end

  create_table "rates", force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "user_id", null: false
    t.integer "reservation_id", null: false
    t.integer "price_range", null: false
    t.integer "cleanliness", null: false
    t.integer "information", null: false
    t.integer "communication", null: false
    t.integer "location", null: false
    t.integer "price", null: false
    t.integer "recommendation", null: false
    t.float "score", null: false
    t.boolean "award", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_value"
    t.index ["price_range"], name: "index_rates_on_price_range"
    t.index ["reservation_id"], name: "index_rates_on_reservation_id"
    t.index ["room_id"], name: "index_rates_on_room_id"
    t.index ["user_id"], name: "index_rates_on_user_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.date "checkin", null: false
    t.date "checkout", null: false
    t.integer "number", null: false
    t.integer "payment", null: false
    t.boolean "cancel", default: false, null: false
    t.boolean "cancel_request", default: false, null: false
    t.integer "guest_id", null: false
    t.integer "host_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "room_id", null: false
    t.index ["guest_id"], name: "index_reservations_on_guest_id"
    t.index ["host_id"], name: "index_reservations_on_host_id"
    t.index ["room_id", "checkin", "checkout"], name: "start_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name", null: false
    t.text "introduction", null: false
    t.integer "fee", null: false
    t.string "adress", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "number"
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: "", null: false
    t.string "introduction", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "notifications", "users", column: "guest_id"
  add_foreign_key "notifications", "users", column: "host_id"
  add_foreign_key "reservations", "rooms"
  add_foreign_key "reservations", "users", column: "guest_id"
  add_foreign_key "reservations", "users", column: "host_id"
end
