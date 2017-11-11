class Scraping
  def concert_info
    concert_infos = []
    agent         = Mechanize.new
    urls          = ['http://okesen.snacle.jp/gakudan/kouendtl/eid/33980',
                     'http://okesen.snacle.jp/gakudan/kouendtl/eid/33970',
                     'http://okesen.snacle.jp/gakudan/kouendtl/eid/33973',
                     'http://okesen.snacle.jp/gakudan/kouendtl/eid/33226',
                     'http://okesen.snacle.jp/gakudan/kouendtl/eid/33223']
    # urls          = ['http://okesen.snacle.jp/gakudan/kouendtl/eid/33980']

    urls.each do |url|
      page = agent.get(url)
      concert_infos << ConcertInfo.new(parth_concert_info(page, url))
    end

    ConcertInfo.delete_all
    ConcertInfo.import(concert_infos)
  end

  private

  def parth_concert_info(page, url)
    {
      concert:       page.search('.concertName').text.presence || '未記入',
      performer:     page.search('.txt').text.gsub(/(のコンサート|楽団・演奏家)/, '').presence || '未記入',
      hall:          page.search('.placeinfo').text.presence || '未記入',
      opening_time:  exclusion_escape_character(page.search('.concertDate').text).presence || '未記入',
      conductor:     page.search('.conductorName').text.presence || '未記入',
      music_titles:  exclusion_escape_character(page.search('p.composer').text).presence || '未記入',
      contact:       parth_contact(page).presence || '未記入',
      performer_url: parth_performer_url(page).presence || '未記入',
      page_url:      url
    }
  end

  def parth_contact(page)
    end_point = page.search('dl dd a').text.index('http')
    page.search('dl dd a').text.slice(0...end_point)
  end

  def parth_performer_url(page)
    start_point = page.search('dl dd').text.index('http')
    end_point   = page.search('dl dd').text.index("\r\n\t\t\t")
    page.search('dl dd').text.slice(start_point...end_point)
  end

  def exclusion_escape_character(text)
    text.gsub(/(\r\n|\t| )/, '')
  end
end
