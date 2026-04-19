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

ActiveRecord::Schema[8.1].define(version: 2026_04_19_154745) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "raw_data", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "payload"
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string "app_id"
    t.text "content"
    t.string "country"
    t.datetime "created_at", null: false
    t.date "date"
    t.integer "rating"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_reviews_on_app_id"
    t.index ["content"], name: "index_reviews_on_content", opclass: :gin_trgm_ops, using: :gin
    t.index ["date"], name: "index_reviews_on_date"
  end
end
