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

ActiveRecord::Schema.define(version: 20131124101559) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adverts", force: true do |t|
    t.integer  "manufacturer_model_id"
    t.integer  "manufacture_year"
    t.datetime "advert_created_at"
    t.text     "url"
    t.text     "images_urls"
    t.text     "thumbnail_url"
    t.boolean  "is_cleared"
    t.boolean  "is_demaged"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price"
    t.text     "description"
    t.string   "city"
  end

  create_table "best_offers", force: true do |t|
    t.integer  "advert_id"
    t.integer  "price_difference"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manufacturer_models", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "manufacturer_id"
  end

  create_table "manufacturers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
