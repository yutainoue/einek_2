class Export
  require 'csv'

  def export_text(concert_infos)
    text = ''

    concert_infos.each.with_index(1) do |c, i|
      text.concat <<~EOS
        =========================
        #{i}. #{c.concert}
        　演奏者名：#{performer(c)}
        　ホール　：#{c.hall} (#{c.hall_prefecture}#{c.hall_ward})
        　開場時間：#{c.opening_time.strftime('%Y年%m月%d日 %H:%M')}
        　開演時間：#{c.tactdown_time.strftime('%Y年%m月%d日 %H:%M')}
        　演奏曲目：#{music_titles(c)}
        　楽団ＨＰ：#{c.performer_url}
        　備考　　：
      EOS
    end

    text << '========================='
  end

  def export_csv(concert_infos)
    CSV.generate do |csv|
      csv_header = %w[No. 演奏会名 ホール名 日程 曲目 HP]
      csv << csv_header

      concert_infos.each.with_index(1) do |c, i|
        ActiveDecorator::Decorator.instance.decorate(c)

        csv_column_values = [
          i,
          c.title,
          c.hall_region,
          c.schedule,
          c.music_title,
          c.performer_url
        ]
        csv << csv_column_values
      end
    end
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
