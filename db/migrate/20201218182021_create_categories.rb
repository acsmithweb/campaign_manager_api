class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :category_name
      t.text :related_words
      t.integer :document_count, :default => 0
      t.string :document_name
      t.string :type

      t.timestamps
    end
  end
end
