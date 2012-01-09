class AvailabilityController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @availability_pages, @availabilities = paginate :availabilities, :per_page => 10
  end

  def show
    @availability = Availability.find(params[:id])
  end

  def new
    @availability = Availability.new
  end

  def create
    @availability = Availability.new(params[:availability])
    if @availability.save
      flash[:notice] = 'Availability was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @availability = Availability.find(params[:id])
  end

  def update
    @availability = Availability.find(params[:id])
    if @availability.update_attributes(params[:availability])
      flash[:notice] = 'Availability was successfully updated.'
      redirect_to :action => 'show', :id => @availability
    else
      render :action => 'edit'
    end
  end

  def destroy
    Availability.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
    def availability
    success = true    
    if (session[:currentSelectedFromDate] and 
        session[:currentSelectedToDate] and 
        not session[:currentSelectedFromDate] .nil? and 
        not session[:currentSelectedToDate] .nil?)
      logger.debug "Updating results to previously selected result date.. : #{ session[:currentSelectedFromDate]}"
      logger.debug "Current Rate ID : #{ session[:currentRateId]}"
      @availabilities = Availability.search(session[:currentSelectedFromDate],session[:currentSelectedToDate], session[:currentRateId])
    end
    
    if (params[:date_range] and params[:commit])
      
      if (params[:rate])
        logger.debug ("In params [:rate]")
        rateId = params[:rate][:id]
        logger.debug "Updating session variables, Rate ID : #{rateId}"
        session[:currentRateId] = rateId
        session[:currentSelectedFromDate] = @from_date
        session[:currentSelectedToDate] = @to_date
      end
      
      logger.debug ("In params [:date_range]")
      @from_date = Date.civil(params[:date_range][:"from_date(1i)"].to_i,
      params[:date_range][:"from_date(2i)"].to_i,
      params[:date_range][:"from_date(3i)"].to_i)
      
      @to_date = Date.civil(params[:date_range][:"to_date(1i)"].to_i,
      params[:date_range][:"to_date(2i)"].to_i,
      params[:date_range][:"to_date(3i)"].to_i)
      
      roomRateId = session[:currentRateId]
      @availabilities = Availability.search(@from_date, @to_date,  roomRateId)
      session[:availabilities] = @availabilities
      session[:currentSelectedFromDate] = @from_date
      session[:currentSelectedToDate] = @to_date
      logger.debug "Updating session variables, From Date  : #{@from_date }"      
      respond_to do |format|
        logger.debug "Sending to rjs file.."
        # format.js tells it that it's a ajax call'
        format.js 
      end # end respond_do
      params[:date_range] = []
      params[:room_rate] = []
      
      logger.debug "Availability result size : #{@availabilities.size}"
    else 
      @availabilities = []
    end
  end
  
  def updateAvailability
    # ruby's exception handling technique
    begin
    
      @availability_ids = params[:room_availability][:"availability_ids"]
      rescue
      logger.debug "No dates have been selected. Cannot perform availability update."
      flash[:notice] = "No dates have been selected. Cannot perform availability update."
      redirect_to :action => 'updateAvailability'
    else
      
      logger.debug "Availability ids : #{ @availability_ids }"  
      roomRateId = session[:currentRateId]
      currentSelectedFromDate =  session[:currentSelectedFromDate]
      currentSelectedToDate =  session[:currentSelectedToDate]
      
      for obj in @availability_ids
        availability = Availability.find(obj)
        
        # get rates inputted from rates screen
        doubleRoomAvailability = params[:roomAvailabilityDoubleRoom]
        singleRoomAvailability = params[:roomAvailabilitySingleRoom]
        twinRoomAvailability = params[:roomAvailabilityTwinRoom]
        tripleRoomAvailability = params[:roomAvailabilityTripleRoom]        

        # check if null, if null - use value read from database
        logger.debug "Updating triple room availability #{ doubleRoomAvailability }"
        if doubleRoomAvailability == ''
          logger.debug "Updating double room availability"
          doubleRoomAvailability = availability.double_room
        end
        
        if singleRoomAvailability == ''
          logger.debug "Updating single room availability"
          singleRoomAvailability = availability.single_room
        end
        
        if twinRoomAvailability == ''
          logger.debug "Updating twin room availability"
          twinRoomAvailability = availability.twin_room
        end
        
        if tripleRoomAvailability == ''
          logger.debug "Updating triple room availability"
          tripleRoomAvailability = availability.triple_room
        end
        
        logger.debug "Updating triple room availability #{ tripleRoomAvailability }"
        # update field values in db
        updated =  availability.update_attributes(:double_room => doubleRoomAvailability, :single_room => singleRoomAvailability, :triple_room => tripleRoomAvailability, :twin_room => twinRoomAvailability)
        logger.debug "Update Status #{updated}"
        if (updated)
          success = true
        else
          success = false             
        end # end if 
      end # end for
      
      # perform additional search and add search results to session
      @availabilities = Availability.search(currentSelectedFromDate, currentSelectedToDate,  roomRateId)
      logger.debug "Availability(s) was successfully updated."
      session[:availabilities] = @availabilities
      logger.debug "Success Status #{success}"
      if success
        logger.debug "Availability(s) was successfully updated."
        logger.debug "Availability result size : #{@availabilities.size}"
        respond_to do |format|
          # nothing after format.js, in this situation it will fall down to updateRate.rjs
          format.js 
        end # end respond_do
        logger.debug "Availability(s) was not successfully updated."
      else
      end # end if success
      
    end
    
  end

  # actions for checkbox functionality - replaced existing javascript.
  def checkWeekends
    logger.debug "in checkWeekends."
    @checkWeekends = true
    @availabilities = session[:availabilities]
  end
  
  def clearAll
    @clearAll = true
    @availabilities = session[:availabilities]
  end
  
  def checkAll
    @checkAll = true
    @availabilities = session[:availabilities]
  end
  
end
