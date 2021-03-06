class Scraping # 将来的には非同期でうごかせるようにする
  require 'log_output'
  include LogOutput
  require 'capybara'
  require 'capybara/poltergeist'
  require 'set'

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

          page = html_parth(url, session)

          # プロオケだったら挟み込みできないので飛ばす
          next if pro_performer?(page)

          concert_info = ConcertInfo.new(parth_concert_info(page, url))

          # 楽団URLがないものは挟み込みの連絡できないため飛ばす
          next unless concert_info.performer_url.start_with?('http')

          hall_prefecture_number_set(concert_info)
          hall_number_set(concert_info)

          concert_infos << concert_info
        rescue => e
          log_warn('コンサート情報ページのスクレイピングに失敗しました', e)
        end
      end
    end

    puts 'スクレイピングが終了しました'

    begin
      ConcertInfo.import(concert_infos)
    rescue => e
      log_error('コンサート情報の更新に失敗しました', e)
    end
  end

  private

  def new_urls(session)
    session    = capybara_init
    # all_urls   = Set.new(concert_info_urls(session))
    all_urls   = Set.new(concert_info_urls(session)[0...10]) # 実装中に大量スクレイピングしないように仮実装
    exist_urls = Set.new(ConcertInfo.pluck(:page_url))
    new_urls   = all_urls - exist_urls
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

  def pro_performer?(page)
    src_name = page.search('.colRight/img').first.attributes['src'].value

    # ico_okeGAKUDAN001.gif = プロオケ
    # ico_okeGAKUDAN002.gif = プロアンサンブル
    # ico_okeGAKUDAN003.gif = プロス吹奏
    # ico_okeGAKUDAN004.gif = プロビックバンド
    # ico_okeGAKUDAN005.gif = プロ独奏
    # ico_okeGAKUDAN006.gif = プロ声楽
    # ico_okeGAKUDAN007.gif = プロ合唱
    # ico_okeGAKUDAN008.gif = プロオペラ
    # ico_okeGAKUDAN009.gif = プロ舞台
    src_name.match(/001|002|003|004|005|006|007|008|009/)
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
