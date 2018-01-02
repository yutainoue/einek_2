class CreateConcertInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :concert_infos do |t|
      t.string   :concert
      t.string   :performer
      t.string   :hall
      t.integer  :hall_number
      t.string   :hall_prefecture
      t.integer  :hall_prefecture_number
      t.string   :hall_ward
      t.datetime :tactdown_time
      t.datetime :opening_time
      t.text     :music_titles
      t.string   :performer_url, null: false
      t.string   :page_url, null: false, unique: true
      t.index    :hall
      t.index    :hall_prefecture
      t.index    :tactdown_time

      t.timestamps
    end
  end
end
