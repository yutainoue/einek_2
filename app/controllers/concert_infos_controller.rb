class ConcertInfosController < ApplicationController
  def index
    @concert_infos = ConcertInfo.all
  end

  def new
    agent        = Mechanize.new
    page         = agent.get('http://okesen.snacle.jp/gakudan/kouendtl/eid/34166')
    concert_name = page.search('.concertName').text
    binding.pry
    redirect_to root_path
  end
end
