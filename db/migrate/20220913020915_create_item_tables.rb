class CreateItemTables < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.text :name
      t.text :details
      t.text :item_type
      t.boolean :magic
      t.integer :ac
      t.float :weight
      t.float :value
      t.text :damage
      t.text :property
      t.text :dmg_type
      t.text :desc
      t.boolean :stealth
      t.text :rolls
    end
  end
end
