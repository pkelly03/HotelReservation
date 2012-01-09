# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def checkIfWeekendRate(id)
    if id == 2
      return true
    else
      return false;
    end
  end
  
  def checkWeekendDay(weekend)
    if weekend == true
      return true
    else 
      return false
    end
  end
  
  def getCheckedStatus (weekendRateSelected, weekendDay)
    checked = false
    
    if weekendRateSelected && weekendDay && @checkWeekends == true
      checked = true
    end

    if @checkAll == true
      checked = true
    end

    return checked
  end
  
  def page_title
    "Ripley Court : #{controller.action_name}"
  end
  def cycle(first_value, *values)
    values.unshift(first_value)
    return Cycle.new(*values)
  end

  class Cycle
    def initialize(first_value, *values)
      @values = values.unshift(first_value)
      @index = 0
    end

    def to_s
      value = @values[@index].to_s
      @index = (@index + 1) % @values.size
      return value
    end
  end
end
