class ConcertInfosController < ApplicationController
  def index
    @search = ConcertInfo.search(params[:q])
    @concert_infos = @search.result.order('tactdown_time ASC')
  end

  def hall_names
    search = ConcertInfo.search(params[:q])
    render partial: 'hall_name', locals: { search: search, prefecture_id: params[:prefecture_id] }
  end

  def new
    Scraping.new.concert_info
    redirect_to root_path
  end
end
