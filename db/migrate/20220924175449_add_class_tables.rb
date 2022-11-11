class AddClassTables < ActiveRecord::Migration[6.0]
  def change
    create_table :base_classes do |t|
      t.string :name
      t.integer :hit_dice
      t.string :proficiencies
      t.integer :num_skills
      t.string :casting_ability
      t.string :armor
      t.string :weapons
      t.string :tools
      t.string :wealth
    end
    create_table :sub_classes do |t|
      t.string :name
      t.integer :base_class_id
    end
    create_table :traits do |t|
      t.text :name
      t.text :details
      t.boolean :optional
      t.integer :class_level
      t.string :parent_type
      t.integer :parent_id
      t.boolean :score_improvement
      t.string :spell_slot
    end
  end
end
