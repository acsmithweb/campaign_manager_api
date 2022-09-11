class AddAdditionalStatBlockFields < ActiveRecord::Migration[6.0]
  def change
    add_column :stat_blocks, :environment, :string
    add_column :stat_blocks, :description, :string
    add_column :stat_blocks, :slots, :string
    add_column :stat_blocks, :spells, :string
  end
end
