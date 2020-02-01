class StatBlock < ApplicationRecord
  validates :name, presence: true, length: {maximum: 32}
  validates :armor_class, presence: true, numericality: true
  validates :hit_points, presence: true, numericality: true
  validates :str, presence: true, numericality: true
  validates :dex, presence: true, numericality: true
  validates :con, presence: true, numericality: true
  validates :int, presence: true, numericality: true
  validates :wis, presence: true, numericality: true
  validates :cha, presence: true, numericality: true
  validates :challenge_rating, presence: true, numericality: true
  validates :experience_points, presence: true, numericality: true
  validates :creature_type, presence: true
end
