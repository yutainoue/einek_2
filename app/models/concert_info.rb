class ConcertInfo < ApplicationRecord
  validates :page_url, presence: true
  validates :page_url, presence: true, uniqueness: true

  scope :unexpired, -> { where("opening_time > ?", Date.today.beginning_of_day) }
end
