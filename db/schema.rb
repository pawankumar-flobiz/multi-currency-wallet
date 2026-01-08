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
ActiveRecord::Schema.define(version: 2026_01_09_055500) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "receiver_id", null: false
    t.uuid "sender_wallet_id", null: false
    t.uuid "receiver_wallet_id", null: false
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.integer "from_currency", null: false
    t.integer "to_currency", null: false
    t.decimal "exchange_rate", precision: 15, scale: 6, null: false
    t.decimal "fee", precision: 15, scale: 2, default: "0.0", null: false
    t.decimal "total_debit", precision: 15, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "otp_secret"
    t.datetime "otp_sent_at"
    t.datetime "email_verified_at"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "wallets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.decimal "balance", precision: 15, scale: 2, default: "0.0", null: false
    t.integer "currency_code", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "currency_code"], name: "index_wallets_on_user_id_and_currency_code", unique: true, where: "(deleted_at IS NULL)"
  end

  add_foreign_key "transactions", "users"
  add_foreign_key "transactions", "users", column: "receiver_id"
  add_foreign_key "transactions", "wallets", column: "receiver_wallet_id"
  add_foreign_key "transactions", "wallets", column: "sender_wallet_id"
  add_foreign_key "wallets", "users"
end
