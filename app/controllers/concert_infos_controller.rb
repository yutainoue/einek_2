class ConcertInfosController < ApplicationController
  def index
    @concert_infos = ConcertInfo.all.order('tactdown_time ASC')
  end

  def new
    Scraping.new.concert_info
    redirect_to root_path
  end
end
