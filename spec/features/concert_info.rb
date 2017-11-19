require 'rails_helper'

describe 'コンサート一覧画面' do
  it 'コンサート情報が表示されていること' do
    create(:concert_info)
    visit concert_info_index_path
    expect(page).to have_content 'index'
    expect(page).to have_content 'ほにゃらら演奏会'
  end
end
