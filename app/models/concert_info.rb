class ConcertInfo < ApplicationRecord
  validates :page_url, presence: true
  validates :page_url, presence: true, uniqueness: true
end
