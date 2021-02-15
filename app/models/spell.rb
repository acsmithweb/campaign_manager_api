class Spell < ApplicationRecord
  include PgSearch::Model

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
  validates :classes, presence: true
end
