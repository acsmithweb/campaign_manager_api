class Item < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search,
    against: [:name, :desc, :type],
    using: {
      tsearch: {
        prefix: true
      }
    }
end
