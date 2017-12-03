require 'rails_helper'

RSpec.describe Scraping do
  describe 'concert_info' do
    it 'コンサート情報を取得できること' do
      # 実際のURLを使うことで、サイト変更にテスト失敗で気づけるようにする
      dummy_urls = ['http://okesen.snacle.jp/gakudan/kouendtl/eid/34168']
      Scraping.any_instance.stub(:concert_info_urls).and_return(dummy_urls)
      expect { Scraping.new.concert_info }.to change { ConcertInfo.count }.by(1)

      concert_info = ConcertInfo.find_by(performer: 'マーキュリーバンド')
      expect(concert_info.concert).to         eq('マーキュリーバンド  25周年記念特別演奏会 〜ゲーム音楽の夕べ〜')
      expect(concert_info.performer).to       eq('マーキュリーバンド')
      expect(concert_info.hall).to            eq('栃木県総合文化センター　メインホール')
      expect(concert_info.hall_prefecture).to eq('栃木県')
      expect(concert_info.hall_ward).to       eq('宇都宮市')
      expect(concert_info.tactdown_time).to   eq('2017-11-03 18:20:00')
      expect(concert_info.opening_time).to    eq('2017-11-03 19:00:00')
      expect(concert_info.music_titles).to    eq('「ドラゴンクエスト」ステージ<br>「ファイナルファンタジー」ステージ<br>')
      expect(concert_info.performer_url).to   eq('http://www.geocities.jp/mercuryband1992/')
      expect(concert_info.page_url).to        eq('http://okesen.snacle.jp/gakudan/kouendtl/eid/34168')
    end

    it '楽団URLが無いものはDBに保存されない' do
      dummy_urls = ['http://okesen.snacle.jp/gakudan/kouendtl/eid/34166']
      Scraping.any_instance.stub(:concert_info_urls).and_return(dummy_urls)
      expect { Scraping.new.concert_info }.not_to change { ConcertInfo.count }
    end
  end
end
