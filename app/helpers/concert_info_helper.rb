module ConcertInfoHelper
  def hall_names(prefecture_id)
    if prefecture_id.blank?
      HallMaster.all
    else
      HallMaster.where(prefecture_id: prefecture_id.to_i)
    end
  end
end
