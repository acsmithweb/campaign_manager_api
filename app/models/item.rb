class Item < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search,
    against: [:name, :desc, :item_type],
    using: {
      tsearch: {
        prefix: true
      }
    }
end
