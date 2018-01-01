class HallMaster < ActiveHash::Base
  self.data = [
    { id: 1, prefecture_id: 1, name: 'id=1' },
    { id: 2, prefecture_id: 1, name: 'id=2' },
    { id: 3, prefecture_id: 2, name: 'id=3' },
    { id: 4, prefecture_id: 2, name: 'id=4' },
    { id: 5, prefecture_id: 2, name: 'id=5' }
  ]
end
