class Availability < ActiveRecord::Base
  belongs_to :booking_info
  
  def self.search(searchFrom, searchTo, rateSpecialId)
    if searchFrom && searchTo
      find_by_sql("select * from availabilities INNER JOIN booking_infos ON availabilities.booking_info_id=booking_infos.id WHERE booking_infos.rate_special_id = #{rateSpecialId} and booking_infos.date between '#{searchFrom}' and '#{searchTo}'")
    else
     logger.debug "empty search"
     []
    end
  end

end
