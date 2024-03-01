class Spell < ApplicationRecord
  include PgSearch::Model

  has_many :workbook_records, :as => :records
  has_many :workbooks, through: :workbook_records

  pg_search_scope :search,
    against: [:name, :desc, :higher_level, :range, :components, :classes, :school, :level, :material, :casting_time],
    using: {
      tsearch: {
        prefix: true
      }
    }

  validates :name, presence: true
  validates :desc, presence: true
  validates :range, presence: true
  validates :components, presence: true
  validates :duration, presence: true
  validates :casting_time, presence: true
  validates :level, presence: true
  validates :school, presence: true

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

    markdown
  end
end
