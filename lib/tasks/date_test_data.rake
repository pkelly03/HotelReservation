desc "Populate AnotherModel with 1000 records" 
# need environment below to access the model object 'AnotherModel''
task :populate_model  => :environment do

   AnotherModel.find(:all)
   d = Date.new(2007, 11,01)
   
   # do the midweek stuff
   100.times do 
     
     puts d.to_yaml
     am = AnotherModel.new 
     am.amount = 50
     am.date = d
     am.rate_id = 1

     # check if weekend, 6 = Sat, 0 = Sun
     if (am.date.wday == 6 || am.date.wday == 0) 
      am.weekend = true
     else 
      am.weekend = false
     end
     am.save
     d = d.succ;
   end
   
   # do the weekend sizzlers..
    d = Date.new(2007, 11,01)
   100.times do 
     am = AnotherModel.new 
     am.amount = 70
     am.date = d
     if (am.date.wday == 6 || am.date.wday == 0) 
      am.weekend = true
     else 
      am.weekend = false
     end
     am.rate_id = 2
     am.save
     d = d.succ
   end

end

   


