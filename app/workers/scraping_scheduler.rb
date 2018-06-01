require 'sidekiq-scheduler'

class ScrapingScheduler
  include Sidekiq::Worker

  def perform
    Scraping.new.concert_info
  end
end
