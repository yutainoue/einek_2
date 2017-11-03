class CreateConcertInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :concert_infos do |t|
      t.string :concert_name
      t.string :hall
      t.date   :tact_down_time
      t.date   :opening_time
      t.string :conductor
      t.text   :music_titles
      t.string :contact_information
      t.string :url

      t.timestamps
    end
  end
end
