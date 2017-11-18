class Scraping
  require 'log_output'
  include LogOutput
  require 'capybara'
  require 'capybara/poltergeist'

  def concert_info
    session       = capybara_init
    urls          = concert_info_urls(session)
    dummy_urls = [urls[0], urls[1], urls[2], urls[3], urls[4]]
    concert_infos = []

    dummy_urls.each do |url|
      begin
        page = html_parth(url, session)
        concert_info = ConcertInfo.new(parth_concert_info(page, url))
        concert_infos << concert_info if concert_info.performer_url.presence
      rescue => e
        log_warn('コンサート情報ページのスクレイピングに失敗しました', e)
      end
    end

    begin
      ConcertInfo.transaction do
        ConcertInfo.all.each(&:destroy!)
        ConcertInfo.import(concert_infos)
      end
    rescue => e
      log_error('コンサート情報の更新に失敗しました', e)
    end
  end

  private

  def capybara_init
    # Capybaraのオプション調べる
    Capybara.run_server = false
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, js_errors: false, timeout: 60)
    end
    Capybara::Session.new(:poltergeist)
  end

  def concert_info_urls(session)
    concert_info_urls = []
    urls = ["http://okesen.snacle.jp/concertlist/three-month/from/#{Date.today.strftime('%Y-%m')}"]
    # "http://okesen.snacle.jp/concertlist/three-month/from/#{(Date.today + 3.months).strftime('%Y-%m')}"]

    urls.each do |url|
      page = html_parth(url, session)
      page.search('tr td a').each do |page|
        concert_info_urls << page.attributes.values[0].value
      end
    end

    concert_info_urls
  end

  def parth_concert_info(page, url)
    {
      concert:       page.search('.concertName').text.presence || '未記入',
      performer:     page.search('.txt').text.gsub(/(のコンサート|楽団・演奏家)/, '').presence || '未記入',
      hall:          page.search('.placeinfo').text.presence || '未記入',
      opening_time:  exclusion_escape_character(page.search('.concertDate').text).presence || '未記入',
      conductor:     page.search('.conductorName').text.presence || '未記入',
      music_titles:  exclusion_escape_character(page.search('p.composer').text).presence || '未記入',
      performer_url: slice_text(page, 'URL：', '直接お問合せする際は'),
      page_url:      url
    }
  end

  def slice_text(page, start_text, end_text)
    start_point = page.text.gsub(/(\r|\n|\t| )/, '').index(start_text) + start_text.length
    end_point   = page.text.gsub(/(\r|\n|\t| )/, '').index(end_text)
    if start_point.presence && end_point.presence
      page.text.gsub(/(\r|\n|\t| )/, '').slice(start_point...end_point)
    end
  end

  def exclusion_escape_character(text)
    text.gsub(/(\r\n|\t| )/, '')
  end

  def html_parth(url, session)
    session.visit(url)
    Nokogiri::HTML.parse(session.html)
  end
end
