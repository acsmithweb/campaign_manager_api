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

  def to_markdown
    data = JSON.parse(self.to_json)

    data.delete('id')
    data.delete('created_at')
    data.delete('updated_at')

    markdown = ""

    data.each do |key, value|
      if value.is_a? String
        markdown += "## #{key.capitalize}\n\n#{value}\n\n"
      elsif value.is_a? Integer
        markdown += "- **#{key.capitalize}:** #{value}\n"
      end
    end

    return markdown
  end
end
