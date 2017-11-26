class CreateConcertInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :concert_infos do |t|
      t.string   :concert
      t.string   :performer
      t.string   :hall
      t.string   :hall_prefecture
      t.string   :hall_ward
      t.datetime :tactdown_time
      t.datetime :opening_time
      t.text     :music_titles
      t.string   :performer_url, null: false
      t.string   :page_url, null: false, unique: true

      t.timestamps
    end
  end
end
