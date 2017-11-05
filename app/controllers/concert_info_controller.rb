class ConcertInfoController < ApplicationController
  def index
    @concert_infos = ConcertInfo.all
  end
end
