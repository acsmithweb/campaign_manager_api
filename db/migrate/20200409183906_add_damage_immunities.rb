class AddDamageImmunities < ActiveRecord::Migration[6.0]
  def change
    add_column :stat_blocks, :damage_immunities, :string
  end
end
