class ConcertInfosController < ApplicationController
  def index
    @search = ConcertInfo.search(params[:q])
    @concert_infos = @search.result.order('tactdown_time ASC')
  end

  def new
    Scraping.new.concert_info
    redirect_to root_path
  end
end
