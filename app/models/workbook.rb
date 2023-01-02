class Workbook < ApplicationRecord
  has_many :workbook_records, dependent: :destroy
  has_many :stat_blocks, through: :workbook_records, source: :record, source_type: 'StatBlock'
  has_many :spells, through: :workbook_records, source: :record, source_type: 'Spell'
  has_many :items, through: :workbook_records, source: :record, source_type: 'Item'

  def add_record(record)
    self.workbook_records.create(record_type: record.class.name, record_id: record.id)
  end

  def records
    all_records = self.stat_blocks + self.spells + self.items
  end
end
