class CreateWorkBookTable < ActiveRecord::Migration[6.0]
  def change
    create_table :workbooks do |t|
      t.string :name
      t.text :notes
      t.integer :user_id
    end
    create_table :workbook_records do |t|
      t.references :record, polymorphic: true
      t.integer :workbook_id
    end
  end
end
