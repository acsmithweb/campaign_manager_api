class Item < ApplicationRecord
  include PgSearch::Model

  has_many :workbook_records, :as => :records
  has_many :workbooks, through: :workbook_records

  pg_search_scope :search,
    against: [:name, :desc, :item_type],
    using: {
      tsearch: {
        prefix: true
      }
    }
end
