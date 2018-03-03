module ConcertInfoDecorator
  def schedule
    date     = opening_time.strftime('%Y年%m月%d日')
    opening  = opening_time.strftime('%H:%M')
    tactdown = tactdown_time.strftime('%H:%M')
    "#{date}<br>開演:#{tactdown} 開場:#{opening}"
  end

  def performer_page_link
    link_to('楽団HP', performer_url, target: '_blank')
  end
end
