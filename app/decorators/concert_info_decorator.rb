module ConcertInfoDecorator
  def title
    if performer.blank?
      return "#{concert}"
    end

    if concert.blank?
      return "#{performer}"
    end

    "【#{performer}】\n#{concert}"
  end

  def hall_region
    "#{hall_prefecture}#{hall_ward}\n#{hall}"
  end

  def schedule
    date     = opening_time.strftime('%Y年%m月%d日')
    opening  = opening_time.strftime('%H:%M')
    tactdown = tactdown_time.strftime('%H:%M')
    "#{date}\n開場:#{opening}\n開演:#{tactdown}"
  end

  def performer_page_link
    #アイコンとの間に余白がほしいから、半角スペース入れている
    link_to(content_tag(:i, ' 楽団HP', class: 'fa fa-external-link'), performer_url, target: '_blank')
  end

  def music_title
    if music_titles.present?
      music_titles
    else
      'HPよりご確認ください。'
    end
  end
end
