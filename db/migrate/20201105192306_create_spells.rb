class CreateSpells < ActiveRecord::Migration[6.0]
  def change
    create_table :spells do |t|
      t.string :name
      t.text :desc
      t.text :higher_level
      t.string :range
      t.string :components
      t.text :material
      t.boolean :ritual
      t.string :duration
      t.boolean :concentration
      t.string :casting_time
      t.integer :level
      t.string :attack_type
      t.text :effect_at_slot_level
      t.text :damage_at_character_level
      t.string :damage_type
      t.string :school
      t.text :classes
      t.text :dc
      t.string :dc_success
      t.text :area_of_effect

      t.timestamps
    end
  end
end
