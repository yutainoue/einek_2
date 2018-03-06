class ExportsController < ApplicationController
  def show
    @concert_infos = ConcertInfo.unexpired.where(id: params[:concert_info_ids].to_a).order('tactdown_time ASC')

    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="挟み込みリスト.xlsx"'
      end

      format.text do
        send_data(Export.new.export_text(@concert_infos), type: 'text', filename: 'test.txt')
      end
    end
  end
end
