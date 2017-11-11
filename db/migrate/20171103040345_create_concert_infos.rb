class CreateConcertInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :concert_infos do |t|
      t.string :concert
      t.string :performer
      t.string :hall
      t.string :opening_time
      t.string :conductor
      t.text   :music_titles
      t.string :contact
      t.string :performer_url
      t.string :page_url

      t.timestamps
    end
  end
end
