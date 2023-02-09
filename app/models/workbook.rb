class Workbook < ApplicationRecord
  include PgSearch::Model

  has_many :workbook_records, dependent: :destroy
  has_many :stat_blocks, through: :workbook_records, source: :record, source_type: 'StatBlock'
  has_many :spells, through: :workbook_records, source: :record, source_type: 'Spell'
  has_many :items, through: :workbook_records, source: :record, source_type: 'Item'

  pg_search_scope :search,
    against: [:name, :notes],
    using: {
      tsearch: {
        prefix: true
      }
    }

  def add_record(record)
    self.workbook_records.create(record_type: record.class.name, record_id: record.id)
  end

  def to_frontend_json
    {
      workbook_data: {
        workbook_id: self.id,
        workbook_name: self.name,
        notes: self.notes,
        user_id: self.user_id
      },
      workbook_records: {
        stat_blocks: self.stat_blocks,
        spells: self.spells,
        items: self.items
      }
    }
  end
end
