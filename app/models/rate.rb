class Rate < ActiveRecord::Base
  belongs_to :rate_special
  belongs_to :room
  
  def self.search(searchFrom, searchTo, rateSpecialId)
    if searchFrom && searchTo
      find(:all, :conditions => ['rate_special_id = ? and date between ? and ?', "#{rateSpecialId}", "#{searchFrom}", "#{searchTo}"])
    else
     logger.debug "empty search"
     []
    end
end

end
