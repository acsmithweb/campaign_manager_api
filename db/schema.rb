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

ActiveRecord::Schema.define(version: 2020_01_25_153513) do

  create_table "stat_blocks", force: :cascade do |t|
    t.string "name"
    t.integer "armor_class"
    t.integer "hit_points"
    t.text "speed"
    t.integer "str"
    t.integer "dex"
    t.integer "con"
    t.integer "int"
    t.integer "wis"
    t.integer "cha"
    t.text "saving_throws"
    t.text "skills"
    t.text "damage_resistance"
    t.text "condition_immunities"
    t.text "senses"
    t.text "languages"
    t.integer "challenge_rating"
    t.integer "experience_points"
    t.text "abilities"
    t.text "actions"
    t.text "legendary_actions"
    t.string "creature_type"
    t.string "alignment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
