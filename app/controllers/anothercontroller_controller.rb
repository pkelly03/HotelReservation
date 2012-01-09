class AnothercontrollerController < ApplicationController
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @another_model_pages, @another_models = paginate :another_models, :per_page => 10
  end

  def show
    @another_model = AnotherModel.find(params[:id])
  end

  def new
    @another_model = AnotherModel.new
  end

  def create
    @another_model = AnotherModel.new(params[:another_model])
    if @another_model.save
      flash[:notice] = 'AnotherModel was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @another_model = AnotherModel.find(params[:id])
  end

  def update
    @another_model = AnotherModel.find(params[:id])

    if @another_model.update_attributes(params[:another_model])
      flash[:notice] = 'AnotherModel was successfully updated.'
      redirect_to :action => 'show', :id => @another_model
    else
      render :action => 'edit'
    end
  end

  def destroy
    AnotherModel.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def rate
     success = true    
     
     if (session[:currentSelectedFromDate] and 
          session[:currentSelectedToDate] and 
          not session[:currentSelectedFromDate] .nil? and 
          not session[:currentSelectedToDate] .nil?)
        logger.debug "Updating results to previously selected result date.. : #{ session[:currentSelectedFromDate]}"
        @testmodels = AnotherModel.search(session[:currentSelectedFromDate],session[:currentSelectedToDate], session[:currentRateId])
     end
     
     
     # check if rate included. If so, do not want to perform a date range search
     if (params[:room_rate])
          logger.debug ("In params [:room_rate]")
         logger.debug "From Date : #{@fromDate}"
         logger.debug "To Date : #{@toDate}"

         @rate_ids = params[:room_rate][:"rate_ids"]
         logger.debug "Rate ids : #{ @rate_ids }"
         roomRateId = session[:currentRateId]
         currentSelectedFromDate =  session[:currentSelectedFromDate]
         currentSelectedToDate =  session[:currentSelectedToDate]

         for obj in @rate_ids
           logger.debug "Updating rate : #{obj} to #{params[:roomRate]}" 
           logger.debug "Using rate id : #{ roomRateId }"
           logger.debug "Current Selected From Date : #{ currentSelectedFromDate }"
           logger.debug "Current Selected To Date : #{ currentSelectedToDate }"
           
           another_model = AnotherModel.find(obj)
           updated =  another_model.update_attributes(:amount => params[:roomRate])
           if (!updated)
            success = false             
           end
         end
         
         if success
            logger.debug "Rate(s) were successfully updated."
           redirect_to :action => 'rate'
          else
           logger.debug "Rate(s) were not successfully updated."
         end
      
    end
     
     if (params[:date_range])

        if (params[:rate])
          logger.debug ("In params [:rate]")
          rateId = params[:rate][:id]
          logger.debug "Updating session variables, Rate ID : #{rateId}"
          session[:currentRateId] = rateId
          session[:currentSelectedFromDate] = @from_date
          session[:currentSelectedToDate] = @to_date
          logger.debug "Rate Id : #{session[:currentRateId] }"
        end

          logger.debug ("In params [:date_range]")
       @from_date = Date.civil(params[:date_range][:"from_date(1i)"].to_i,
                               params[:date_range][:"from_date(2i)"].to_i,
                               params[:date_range][:"from_date(3i)"].to_i)

       @to_date = Date.civil(params[:date_range][:"to_date(1i)"].to_i,
                             params[:date_range][:"to_date(2i)"].to_i,
                             params[:date_range][:"to_date(3i)"].to_i)
                             
        logger.debug "Rate Id before Search : #{session[:currentRateId] }"
        roomRateId = session[:currentRateId]
        logger.debug "From Date : #{@fromDate}"
        logger.debug "To Date : #{@toDate}"
        logger.debug "Rate ID : #{roomRateId}" 

        @testmodels = AnotherModel.search(@from_date, @to_date,  roomRateId)
#        session[:roomrateid] = @new_message
             
        
       logger.debug "Rate result size : #{@testmodels.size}"
     else 
      @testmodels = []
     end
  end

  def updateRate
     logger.debug "in updateRate"
     @another_model = AnotherModel.find(params[:id])
     # param rate is 2d array, like this "rate"=>{"rate"=>"25"}
     # save to updatedRate and cast to int
     logger.debug(params[:id])
     rate = params[:id]
     logger.debug("Rate : #{@rate}")
     updatedRate = params[:rate][:rate].to_i
     if @another_model.update_attributes(:rate => updatedRate)
      flash[:notice] = 'Rate was successfully updated.'
      redirect_to :action => 'show', :id => @another_model
    else
      render :action => 'edit'
    end
  end

  def updateRatesForCheckedDates
      logger.debug "in updateRatesForCheckedDates"

  end

  end