class Export
  def self.export_text(concert_infos)
    text = ''

    concert_infos.each.with_index(1) do |c, i|
      text.concat <<~EOS
        =========================
        #{i},#{c.concert}
        　楽団名　：#{c.performer}
        　楽団ＨＰ：#{c.performer_url}
        　開演時間：#{c.tactdown_time.strftime('%Y年%m月%d日 %H:%M')}
        　開場時間：#{c.opening_time.strftime('%Y年%m月%d日 %H:%M')}
        　演奏曲目：#{c.music_titles.gsub('<br>', "\n　　　　　　")}
        　ホール　：#{c.hall}
        　備考　　：
      EOS
    end

    text << '========================='
  end
end
