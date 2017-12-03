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

ActiveRecord::Schema.define(version: 20171103040345) do

  create_table "concert_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "concert"
    t.string "performer"
    t.string "hall"
    t.string "hall_prefecture"
    t.string "hall_ward"
    t.datetime "tactdown_time"
    t.datetime "opening_time"
    t.text "music_titles"
    t.string "performer_url", null: false
    t.string "page_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hall"], name: "index_concert_infos_on_hall"
    t.index ["hall_prefecture"], name: "index_concert_infos_on_hall_prefecture"
    t.index ["tactdown_time"], name: "index_concert_infos_on_tactdown_time"
  end

end
