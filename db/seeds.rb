10.times do |no|
  ConcertInfo.create(
    concert_name:        "演奏会その#{no}",
    hall:                "ホール名その#{no}",
    tact_down_time:      Time.current,
    opening_time:        Time.current,
    conductor:           "山田 #{no}太郎",
    music_titles:        "ほにゃらら作曲 交響曲#{no}1番<br>ほにゃらら作曲 交響曲#{no}2番<br>ほにゃらら作曲 交響曲#{no}3番",
    contact_information: "einek#{no}@example.com",
    url:                 "http://concert-#{no}"
  )
end
