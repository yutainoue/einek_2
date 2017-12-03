10.times do |no|
  ConcertInfo.create(
    concert:         "演奏会その#{no}",
    performer:       "オーケストラその#{no}",
    hall:            "ホール名その#{no}",
    hall_prefecture: "#{no}県",
    hall_ward:       "#{no}区",
    tactdown_time:   Time.now,
    opening_time:    Time.now,
    music_titles:    "ほにゃらら作曲 交響曲#{no}1番<br>
                      ほにゃらら作曲 交響曲#{no}2番<br>
                      ほにゃらら作曲 交響曲#{no}3番",
    performer_url:   "http://concert-#{no}",
    page_url:        "http://hoge-#{no}"
  )
end
