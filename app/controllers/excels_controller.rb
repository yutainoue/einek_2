class ExcelsController < ApplicationController
  def show
    @search = ConcertInfo.search(params[:q])
    @concert_infos = @search.result.order('tactdown_time ASC')

    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="挟み込みリスト.xlsx"'
      end
    end
  end
end
