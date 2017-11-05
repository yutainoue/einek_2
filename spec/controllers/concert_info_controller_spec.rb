require 'rails_helper'

RSpec.describe ConcertInfoController do
  describe 'index' do
    it '一覧画面の表示に成功すること' do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end
end
