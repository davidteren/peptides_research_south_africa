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

ActiveRecord::Schema[8.1].define(version: 2026_08_26_074260) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "compounds", force: :cascade do |t|
    t.string "classification"
    t.string "confidence"
    t.datetime "created_at", null: false
    t.string "evidence_grade"
    t.date "last_reviewed_at"
    t.string "name", null: false
    t.json "payload"
    t.string "slug", null: false
    t.text "summary"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_compounds_on_slug", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.bigint "compound_id", null: false
    t.string "confidence"
    t.datetime "created_at", null: false
    t.string "form"
    t.date "last_reviewed_at"
    t.json "payload"
    t.boolean "price_visible_without_login"
    t.decimal "price_zar"
    t.string "product_url"
    t.bigint "provider_id", null: false
    t.string "route"
    t.string "slug", null: false
    t.string "strength"
    t.string "title_on_page"
    t.datetime "updated_at", null: false
    t.index ["compound_id"], name: "index_products_on_compound_id"
    t.index ["provider_id"], name: "index_products_on_provider_id"
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "providers", force: :cascade do |t|
    t.string "city"
    t.string "confidence"
    t.datetime "created_at", null: false
    t.string "kind"
    t.date "last_reviewed_at"
    t.string "listing_posture"
    t.string "name", null: false
    t.json "payload"
    t.string "prescription_required"
    t.string "slug", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["slug"], name: "index_providers_on_slug", unique: true
  end

  add_foreign_key "products", "compounds"
  add_foreign_key "products", "providers"
end
