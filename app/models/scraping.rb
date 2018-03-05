class Scraping # 将来的には非同期でうごかせるようにする
  require 'log_output'
  include LogOutput
  require 'capybara'
  require 'capybara/poltergeist'

  def concert_info
    session = capybara_init
    concert_infos = []
    concert_urls = new_urls(session)
    urls_count = concert_urls.count

    concert_urls.each_slice(20) do |urls|
      urls_count -= 20
      puts '=============================='
      puts "残り：#{urls_count}"
      urls.each do |url|
        begin
          puts "url:#{url}"
          sleep 2 # 怒られないように2秒待つ

          page         = html_parth(url, session)
          concert_info = ConcertInfo.new(parth_concert_info(page, url))
          hall_prefecture_number_set(concert_info)
          hall_number_set(concert_info)

          # 楽団URLがないものは挟み込みの連絡できないため必要ない
          if concert_info.performer_url.start_with?('http')
            concert_infos << concert_info
          end
        rescue => e
          log_warn('コンサート情報ページのスクレイピングに失敗しました', e)
        end
      end
    end

    puts 'Scraping Done'
    # 先月のコンサート情報を削除する
    # 将来的には別メソッドにしよう
    old_concert = ConcertInfo.all.select { |x| x.tactdown_time < Time.now.beginning_of_month }

    begin
      ConcertInfo.transaction do
        # old_concert.each(&:destroy!)
        ConcertInfo.import(concert_infos)
      end
    rescue => e
      log_error('コンサート情報の更新に失敗しました', e)
    end
  end

  private

  def new_urls(session)
    session    = capybara_init
    all_urls   = concert_info_urls(session)
    all_urls   = all_urls[0..100] # 実装中に大量スクレイピングしないように仮実装
    exist_urls = ConcertInfo.pluck(:page_url)
    new_urls   = all_urls.select { |url| exist_urls.exclude?(url) }
    new_urls
  end

  def capybara_init
    Capybara.run_server = false
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, js_errors: false, timeout: 60)
    end
    Capybara::Session.new(:poltergeist)
  end

  def concert_info_urls(session)
    concert_info_urls = []
    urls = [#{}"http://okesen.snacle.jp/concertlist/three-month/from/#{Date.today.strftime('%Y-%m')}",
            "http://okesen.snacle.jp/concertlist/three-month/from/#{(Date.today + 3.months).strftime('%Y-%m')}"]

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
      concert:         page.search('.concertName').text,
      performer:       page.search('.txt').text.gsub(/(のコンサート|楽団・演奏家)/, ''),
      hall:            hall_parse(page.search('.placeinfo').text),
      hall_prefecture: hall_prefecture_parse(page.search('.placeinfo').text),
      hall_ward:       hall_ward_parse(page.search('.placeinfo').text),
      opening_time:    tactdown_time_parse(exclusion_escape_character(page.search('.concertDate').text)),
      tactdown_time:   opening_time_parse(exclusion_escape_character(page.search('.concertDate').text)),
      music_titles:    exclusion_escape_character(page.search('p.composer').text).chomp,
      performer_url:   slice_text(page, 'URL：', '直接お問合せする際は'),
      page_url:        url
    }
  end

  def slice_text(page, start_text, end_text)
    text        = page.text.gsub(/(\r|\n|\t| )/, '')
    start_point = text.index(start_text) + start_text.length
    end_point   = text.index(end_text)
    if start_point.presence && end_point.presence
      text.slice(start_point...end_point)
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

  def hall_parse(text)
    return if text.blank?
    end_point = text.index('（')
    text[0...end_point]
  end

  def hall_prefecture_parse(text)
    return if text.blank?
    text = text[/（(.*?)）/, 1].gsub(/ |　|/, '')
    end_point = text.index(/都|道|府|県/)

    end_point = 2 if text.include?('京都府')
    text[0..end_point]
  end

  def hall_ward_parse(text)
    return if text.blank?
    text = text[/（(.*?)）/, 1].gsub(/ |　|/, '')
    start_point = text.index(/都|道|府|県/) + 1
    end_point = text.length

    start_point = 3 if text.include?('京都府')
    text[start_point..end_point]
  end

  def hall_prefecture_number_set(concert_info)
    PrefectureMaster.all.each do |prefecture|
      if concert_info.hall_prefecture == prefecture.name
        concert_info.hall_prefecture_number = prefecture.id
        break
      end
    end
  end

  def hall_number_set(concert_info)
    prefecture_halls = HallMaster.where(prefecture_id: concert_info.hall_prefecture_number)

    prefecture_halls.each do |hall|
      break if concert_info.hall_prefecture_number.blank?

      hall.search_name.split(',').each do |name|
        if concert_info.hall.match?(/#{name}/)
          concert_info.hall_number = hall.id
          break
        end
      end
    end
  end
end
