namespace :ripley do
  
  desc "Populate Rates for a certain date period" 
  # need environment below to access the model object 'AnotherModel''
  task :populate_rates  => :environment do
    
    Rate.delete_all
    d = Date.new(2007, 11,20)
    
    # do the midweek stuff
    100.times do 
      
      rate = Rate.new 
      rate.single_room = 50
      rate.double_room = 70
      rate.triple_room = 110     
      rate.twin_room = 70
      rate.date = d
      rate.rate_special_id = 1
      
      # check if weekend, 6 = Sat, 0 = Sun
      if (rate.date.wday == 6 || rate.date.wday == 0) 
        rate.weekend = true
      else 
        rate.weekend = false
      end
      rate.save
      d = d.succ;
    end
    
    # do the weekend sizzlers..
    d = Date.new(2007, 11,01)
    100.times do 
      rate = Rate.new 
      rate.single_room = 50
      rate.double_room = 70
      rate.triple_room = 110     
      rate.twin_room = 70
      rate.date = d
      if (rate.date.wday == 6 || rate.date.wday == 0) 
        rate.weekend = true
      else 
        rate.weekend = false
      end
      rate.rate_special_id = 2
      rate.save
      d = d.succ
    end
    
  end

    desc "Populate Rates Specials table" 
  task :populate_ratespecials  => :environment do

    RateSpecial.delete_all
    n1 = RateSpecial.new
    n1.id = 1
    n1.shortname = 'Midweek Sizzlers'
    n1.longname = 'Midweek Sizzlers'
    n1.save
    
    n2 = RateSpecial.new
    n2.id = 2
    n2.shortname = 'Weekend Sizzlers'
    n2.longname = 'Weekend Sizzlers'
    n2.save
  end

  desc "Populate Rates Specials table" 
  task :populate_rooms  => :environment do

    Room.delete_all
    room = Room.new
    room.id = 1
    room.room = 'Double Room'
    room.description = 'Double Room'
    room.save

    room = Room.new
    room.id = 2
    room.room = 'Single Room'
    room.description = 'Single Room'
    room.save

    room = Room.new
    room.id = 3
    room.room = 'Twin Room'
    room.description = 'Twin Room'
    room.save

    room = Room.new
    room.id = 4
    room.room = 'Single Room'
    room.description = 'Single Room'
    room.save
  end

  
  desc "Adds a user to the database" 
  task :add_user  => :environment do
    
    unless ENV.include?("user") && ENV.include?("password")
      raise "usage: rake add_user user=X password=Y" 
    end

    puts "Adding new user #{ENV['user']}"
    @user = User.new

    @user.name = ENV['user']
    @user.password = ENV['password']
    

  end


  desc "Populate Rates for a certain date period" 
  # need environment below to access the model object 'AnotherModel''
  task :populate_availability  => :environment do
    
    Availability.delete_all
    BookingInfo.delete_all
    d = Date.new(2007, 11,20)
    
    # do the midweek stuff
    100.times do 
      availability = Availability.new 
      availability.single_room = 3
      availability.double_room = 5
      availability.triple_room = 3     
      availability.twin_room = 0

      bookingInfo = BookingInfo.new
      bookingInfo.date = d
      bookingInfo.rate_special_id = 1
      # check if weekend, 6 = Sat, 0 = Sun
      if (bookingInfo.date.wday == 6 || bookingInfo.date.wday == 0) 
        bookingInfo.weekend = true
      else 
        bookingInfo.weekend = false
      end
      availability.booking_info = bookingInfo
      availability.save
      d = d.succ;
    end
    

    # do the weekend sizzlers..
    d = Date.new(2007, 11,01)
    100.times do 

      availability = Availability.new 
      availability.single_room = 3
      availability.double_room = 5
      availability.triple_room = 3     
      availability.twin_room = 0

      bookingInfo = BookingInfo.new
      bookingInfo.date = d
      bookingInfo.rate_special_id = 2
      # check if weekend, 6 = Sat, 0 = Sun
      if (bookingInfo.date.wday == 6 || bookingInfo.date.wday == 0) 
        bookingInfo.weekend = true
      else 
        bookingInfo.weekend = false
      end
      availability.booking_info = bookingInfo
      availability.save
      
      d = d.succ;
      
    end
    
  end

end



