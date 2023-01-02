class WorkbookRecord < ApplicationRecord
  belongs_to :workbook
  belongs_to :record, polymorphic: true
end
