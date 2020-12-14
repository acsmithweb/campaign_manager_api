class CreateStatBlocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stat_blocks do |t|
      t.string :name
      t.text :size
      t.integer :armor_class
      t.integer :hit_points
      t.text :hit_dice
      t.text :speed
      t.integer :str
      t.integer :dex
      t.integer :con
      t.integer :int
      t.integer :wis
      t.integer :cha
      t.text :saving_throws
      t.text :skills
      t.text :damage_resistance
      t.text :condition_immunities
      t.text :damage_immunities
      t.text :vulnerability
      t.text :senses
      t.text :languages
      t.integer :challenge_rating
      t.integer :experience_points
      t.text :abilities
      t.text :actions
      t.text :legendary_actions
      t.string :creature_type
      t.string :alignment

      t.timestamps
    end
  end
end
