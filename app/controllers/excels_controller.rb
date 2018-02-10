class ExcelsController < ApplicationController
  def show
    @concert_infos = ConcertInfo.where(id: params[:concert_info_ids].to_a).order('tactdown_time ASC')

    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="挟み込みリスト.xlsx"'
      end
    end
  end
end
