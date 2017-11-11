class ConcertInfosController < ApplicationController
  def index
    @concert_infos = ConcertInfo.all
  end

  def new
    # ConcertInfo作成クラスを作って、そっちでスクレイピング・保存する
    # ConcertInfoモデルはイニシャライズするだけ
    Scraping.new.concert_info
    redirect_to root_path
  end
end
