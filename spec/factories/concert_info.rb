FactoryBot.define do
  factory :concert_info do
    concert             'ほにゃらら演奏会'
    performer           'ほにゃらら楽団'
    hall                'ほにゃららホール'
    hall_prefecture     '東京都'
    hall_ward           '新宿区'
    tactdown_time       Time.current
    opening_time        Time.current
    music_titles        '交響曲ほにゃらら'
    performer_url       'http://xxx'
    page_url            'http://yyy'
  end
end
