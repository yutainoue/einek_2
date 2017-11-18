require 'rails_helper'

RSpec.describe Scraping do
  describe 'concert_info' do
    it 'コンサート情報を取得できること' do
      # 実際のURLを使うことで、サイト変更にテスト失敗で気づけるようにする
      dummy_urls = ['http://okesen.snacle.jp/gakudan/kouendtl/eid/34168',
                    'http://okesen.snacle.jp/gakudan/kouendtl/eid/34166',
                    'http://okesen.snacle.jp/gakudan/kouendtl/eid/33829',
                    'http://okesen.snacle.jp/gakudan/kouendtl/eid/34026',
                    'http://okesen.snacle.jp/gakudan/kouendtl/eid/34024']
      Scraping.any_instance.stub(:concert_info_urls).and_return(dummy_urls)
      expect { Scraping.new.concert_info }.to change { ConcertInfo.count }.by(4)

      concert_info = ConcertInfo.find_by(performer: 'マーキュリーバンド')
      expect(concert_info.concert).to       eq('マーキュリーバンド  25周年記念特別演奏会 〜ゲーム音楽の夕べ〜')
      expect(concert_info.hall).to          eq('栃木県総合文化センター　メインホール（栃木県宇都宮市 ）')
      expect(concert_info.opening_time).to  eq("2017/11/03(金)\n19:00開演（18:20開場）")
      expect(concert_info.conductor).to     eq('鈴木　章郎／五十嵐　貴宏')
      expect(concert_info.music_titles).to  eq("「ドラゴンクエスト」ステージ\n「ファイナルファンタジー」ステージ\n")
      expect(concert_info.performer_url).to eq('http://www.geocities.jp/mercuryband1992/')
    end
  end
end
