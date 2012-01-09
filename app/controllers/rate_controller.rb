class RateController < ApplicationController
  
  before_filter :authorize, :except => :login
  
  @rates = []
  
  
  def index
    list
    @records = Rate.find(:all)
    render :action => 'list'
  end
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :list }
  
  def list
    @rate_pages, @rates = paginate :rates, :per_page => 10
  end
  
  def show
    @rate = Rate.find(params[:id])
  end
  
  def new
    @rate = Rate.new
  end
  
  def create
    @rate = Rate.new(params[:rate])
    if @rate.save
      flash[:notice] = 'Rate was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @rate = Rate.find(params[:id])
  end
  
  def update
    @rate = Rate.find(params[:id])
    
    if @rate.update_attributes(params[:rate])
      flash[:notice] = 'Rate was successfully updated.'
      redirect_to :action => 'show', :id => @rate
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    begin   
      Rate.find(params[:id]).destroy
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to destroy invalid rate #{params[:id]}")
      redirect_to_index("Invalid rate")
    else
      redirect_to :action => 'list'
     end
  end
  
  def rate
    success = true    
    if (session[:currentSelectedFromDate] and 
        session[:currentSelectedToDate] and 
        not session[:currentSelectedFromDate] .nil? and 
        not session[:currentSelectedToDate] .nil?)
      logger.debug "Updating results to previously selected result date.. : #{ session[:currentSelectedFromDate]}"
      @rates = Rate.search(session[:currentSelectedFromDate],session[:currentSelectedToDate], session[:currentRateId])
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
      @rates = Rate.search(@from_date, @to_date,  roomRateId)
      session[:rates] = @rates
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
      
      logger.debug "Rate result size : #{@rates.size}"
    else 
      @rates = []
    end
  end
  
  def updateRate
    # ruby's exception handling technique
    begin
    
      @rate_ids = params[:room_rate][:"rate_ids"]
      rescue
      logger.debug "No rates have been selected. Cannot perform rate update."
      flash[:notice] = "No rates have been selected. Cannot perform rate update."
      redirect_to :action => 'updateRate'
    else
      
      logger.debug "Rate ids : #{ @rate_ids }"  
      roomRateId = session[:currentRateId]
      currentSelectedFromDate =  session[:currentSelectedFromDate]
      currentSelectedToDate =  session[:currentSelectedToDate]
      
      for obj in @rate_ids
        rate = Rate.find(obj)
        
        # get rates inputted from rates screen
        doubleRoomRate = params[:roomRateDoubleRoom]
        singleRoomRate = params[:roomRateSingleRoom]
        twinRoomRate = params[:roomRateTwinRoom]
        tripleRoomRate = params[:roomRateTripleRoom]        
        
        # check if null, if null - use value read from database
        if doubleRoomRate == ''
          doubleRoomRate = rate.double_room
        end
        
        if singleRoomRate == ''
          singleRoomRate = rate.single_room
        end
        
        if twinRoomRate == ''
          twinRoomRate = rate.twin_room
        end
        
        if tripleRoomRate == ''
          tripleRoomRate = rate.triple_room
        end
        
        # update field values in db
        updated =  rate.update_attributes(:double_room => doubleRoomRate, :single_room => singleRoomRate, :triple_room => tripleRoomRate, :twin_room => twinRoomRate)
        if (!updated)
          success = false             
        end # end if 
      end # end for
      
      # perform additional search and add search results to session
      @rates = Rate.search(currentSelectedFromDate, currentSelectedToDate,  roomRateId)
      session[:rates] = @rates
      if success
        logger.debug "Rate(s) were successfully updated."
        logger.debug "Rate result size : #{@rates.size}"
        respond_to do |format|
          # nothing after format.js, in this situation it will fall down to updateRate.rjs
          format.js 
        end # end respond_do
      else
        logger.debug "Rate(s) were not successfully updated."
      end # end if success
      
    end
    
  end

  # actions for checkbox functionality - replaced existing javascript.
  def checkWeekends
    logger.debug "in checkWeekends."
    @checkWeekends = true
    @rates = session[:rates]
  end
  
  def clearAll
    @clearAll = true
    @rates = session[:rates]
  end
  
  def checkAll
    @checkAll = true
    @rates = session[:rates]
  end
  
end