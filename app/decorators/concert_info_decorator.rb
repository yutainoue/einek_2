module ConcertInfoDecorator
  def title
    "#{concert}<br>(演奏:#{performer})"
  end

  def schedule
    date     = opening_time.strftime('%Y年%m月%d日')
    opening  = opening_time.strftime('%H:%M')
    tactdown = tactdown_time.strftime('%H:%M')
    "#{date}<br>開演:#{tactdown} 開場:#{opening}"
  end

  def performer_page_link
    # fa_icon 'twitter'
    link_to(content_tag(:i, '', class: 'fa fa-external-link'), performer_url, target: '_blank')
    # link_to(performer_url, target: '_blank')
  end
end