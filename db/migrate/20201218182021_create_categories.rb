class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :category_type
      t.text :related_words
      t.integer :document_count, :default => 0

      t.timestamps
    end
  end
end
