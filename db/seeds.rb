10.times do |no|
  ConcertInfo.create(
    concert:        "演奏会その#{no}",
    performer:      "オーケストラその#{no}",
    hall:           "ホール名その#{no}",
    opening_time:   '2017年1月1日',
    conductor:      "山田 #{no}太郎",
    music_titles:   "ほにゃらら作曲 交響曲#{no}1番<br>
                     ほにゃらら作曲 交響曲#{no}2番<br>
                     ほにゃらら作曲 交響曲#{no}3番",
    performer_url:  "http://concert-#{no}",
    page_url:       "http://hoge-#{no}"
  )
end
