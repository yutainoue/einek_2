class Scraping
  require 'log_output'
  include LogOutput
  require 'capybara'
  require 'capybara/poltergeist'

  def concert_info
    session    = capybara_init
    all_urls   = concert_info_urls(session)
    all_urls   = all_urls[0..30]
    exist_urls = ConcertInfo.pluck(:page_url)
    new_urls   =  all_urls.select { |url| exist_urls.exclude?(url) }
    concert_infos = []
    puts "new_urls:#{new_urls.count}"

    new_urls.each_slice(20) do |urls|
      puts '====='
      urls.each do |url|
        begin
          puts "url:#{url}"
          # 怒られないように2秒待つ
          sleep 3
          page         = html_parth(url, session)
          concert_info = ConcertInfo.new(parth_concert_info(page, url))

          # 楽団URLがないものは挟み込みの連絡できないため必要ない
          concert_infos << concert_info if concert_info.performer_url.present?
        rescue => e
          log_warn('コンサート情報ページのスクレイピングに失敗しました', e)
        end
      end
    end

    puts 'Scraping Done'
    # 先月のコンサート情報を削除する
    old_concert = ConcertInfo.all.select { |x| x.tactdown_time < Time.now.beginning_of_month }
    begin
      ConcertInfo.transaction do
        old_concert.each(&:destroy!)
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
      concert:       page.search('.concertName').text,
      performer:     page.search('.txt').text.gsub(/(のコンサート|楽団・演奏家)/, ''),
      hall:          page.search('.placeinfo').text,
      tactdown_time: tactdown_time_parse(exclusion_escape_character(page.search('.concertDate').text)),
      opening_time:  opening_time_parse(exclusion_escape_character(page.search('.concertDate').text)),
      conductor:     page.search('.conductorName').text,
      music_titles:  exclusion_escape_character(page.search('p.composer').text),
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

  def tactdown_time_parse(text)
    return if text.blank?
    text[10..21] = ' '
    DateTime.parse(text[0..15])
  end

  def opening_time_parse(text)
    return if text.blank?
    text[10..13] = ' '
    DateTime.parse(text[0..15])
  end
end
