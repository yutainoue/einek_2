class HallMaster < ActiveHash::Base
  self.data = [
    # 北海道
    { id: 1, prefecture_id: 1, search_name: '', name: '札幌コンサートホールKitara' },
    { id: 2, prefecture_id: 1, search_name: '', name: '札幌市教育文化会館' },
    { id: 3, prefecture_id: 1, search_name: '', name: 'ニトリ文化ホール' },
    { id: 4, prefecture_id: 1, search_name: '', name: 'ザ・ルーテルホール' },
    { id: 5, prefecture_id: 1, search_name: '', name: 'ふきのとうホール' },
    { id: 6, prefecture_id: 1, search_name: '', name: '函館市民会館' },
    { id: 7, prefecture_id: 1, search_name: '', name: '函館市芸術ホール' },
    { id: 8, prefecture_id: 1, search_name: '', name: '旭川市民文化会館' },
    { id: 9, prefecture_id: 1, search_name: '', name: '旭川市大雪クリスタルホール' },
    { id: 10, prefecture_id: 1, search_name: '', name: '北見市民会館' },
    { id: 11, prefecture_id: 1, search_name: '', name: '北見芸術文化ホール' },
    { id: 12, prefecture_id: 1, search_name: '', name: '帯広市民文化ホール' },
    { id: 13, prefecture_id: 1, search_name: '', name: '釧路市民文化会館' },
    { id: 14, prefecture_id: 13, search_name: 'ZERO', name: 'なかのZERO' }
  ]
end
