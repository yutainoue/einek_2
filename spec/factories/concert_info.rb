FactoryBot.define do
  factory :concert_info do
    concert             'ほにゃらら演奏会'
    performer           'ほにゃらら楽団'
    hall                'ほにゃららホール'
    opening_time        Time.current
    conductor           'ほにゃららさん'
    music_titles        '交響曲ほにゃらら'
    contact_information 'xxx@example.com'
    performer_url       'http://xxx'
    page_url            'http://yyy'
  end
end
