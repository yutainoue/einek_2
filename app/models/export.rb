class Export
  def export_text(concert_infos)
    text = ''

    concert_infos.each.with_index(1) do |c, i|
      text.concat <<~EOS
        =========================
        #{i},#{c.concert}
        　演奏者名：#{performer(c)}
        　楽団ＨＰ：#{c.performer_url}
        　開演時間：#{c.tactdown_time.strftime('%Y年%m月%d日 %H:%M')}
        　開場時間：#{c.opening_time.strftime('%Y年%m月%d日 %H:%M')}
        　演奏曲目：#{music_titles(c)}
        　ホール　：#{c.hall}
        　備考　　：
      EOS
    end

    text << '========================='
  end

  private

  def performer(concert_info)
    if concert_info.performer.present?
      concert_info.performer
    else
      'HPよりご確認ください。'
    end
  end

  def music_titles(concert_info)
    if concert_info.music_titles.present?
      concert_info.music_titles.gsub("\n", "\n　　　　　　")
    else
      'HPよりご確認ください。'
    end
  end
end
