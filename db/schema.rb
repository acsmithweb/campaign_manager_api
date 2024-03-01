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

ActiveRecord::Schema.define(version: 2022_12_22_150209) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "base_classes", force: :cascade do |t|
    t.string "name"
    t.integer "hit_dice"
    t.string "proficiencies"
    t.integer "num_skills"
    t.string "casting_ability"
    t.string "armor"
    t.string "weapons"
    t.string "tools"
    t.string "wealth"
  end

  create_table "categories", force: :cascade do |t|
    t.string "category_type"
    t.text "related_words"
    t.integer "document_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "items", force: :cascade do |t|
    t.text "name"
    t.text "details"
    t.text "item_type"
    t.boolean "magic"
    t.integer "ac"
    t.float "weight"
    t.float "value"
    t.text "damage"
    t.text "property"
    t.text "dmg_type"
    t.text "desc"
    t.boolean "stealth"
    t.text "rolls"
  end

  create_table "spells", force: :cascade do |t|
    t.string "name"
    t.text "desc"
    t.text "higher_level"
    t.string "range"
    t.string "components"
    t.text "material"
    t.boolean "ritual"
    t.string "duration"
    t.boolean "concentration"
    t.string "casting_time"
    t.integer "level"
    t.string "attack_type"
    t.text "heal_at_slot_level"
    t.text "damage_at_slot_level"
    t.text "damage_at_character_level"
    t.string "damage_type"
    t.string "school"
    t.text "classes"
    t.text "dc"
    t.string "dc_success"
    t.text "area_of_effect"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stat_blocks", force: :cascade do |t|
    t.text "name"
    t.text "size"
    t.integer "armor_class"
    t.integer "hit_points"
    t.text "hit_dice"
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
    t.text "damage_immunities"
    t.text "vulnerability"
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
    t.string "environment"
    t.string "description"
    t.string "slots"
    t.string "spells"
  end

  create_table "sub_classes", force: :cascade do |t|
    t.string "name"
    t.integer "base_class_id"
  end

  create_table "traits", force: :cascade do |t|
    t.text "name"
    t.text "details"
    t.boolean "optional"
    t.integer "class_level"
    t.string "parent_type"
    t.integer "parent_id"
    t.boolean "score_improvement"
    t.string "spell_slot"
  end

  create_table "workbook_records", force: :cascade do |t|
    t.string "record_type"
    t.bigint "record_id"
    t.integer "workbook_id"
    t.index ["record_type", "record_id"], name: "index_workbook_records_on_record_type_and_record_id"
  end

  create_table "workbooks", force: :cascade do |t|
    t.string "name"
    t.text "notes"
    t.integer "user_id"
  end

end
