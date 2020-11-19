class Spell < ApplicationRecord
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
