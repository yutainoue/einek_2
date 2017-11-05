FactoryGirl.define do
  factory :concert_info do
    concert_name        'ほにゃらら演奏会'
    performer_name      'ほにゃらら楽団'
    hall                'ほにゃららホール'
    tact_down_time      Time.current
    opening_time        Time.current
    conductor           'ほにゃららさん'
    music_titles        '交響曲ほにゃらら'
    contact_information 'xxx@example.com'
    url                 'http://xxx'
  end
end
