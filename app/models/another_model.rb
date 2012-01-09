class AnotherModel < ActiveRecord::Base

def self.search(searchFrom, searchTo, rateId)
    if searchFrom && searchTo
      logger.debug "searchFrom listed, Rate ID : #{rateId}"
      find(:all, :conditions => ['rate_id = ? and date between ? and ?', "#{rateId}", "#{searchFrom}", "#{searchTo}"])
    else
     logger.debug "empty search"
     []
    end

 end

end
