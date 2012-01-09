class AddTestData < ActiveRecord::Migration
  def self.up
    RateSpecial.delete_all
    Room.delete_all
    RateSpecial.create(:shortname => 'Midweek Sizzlers', :longname => 'Midweek Sizzlers')
    RateSpecial.create(:shortname => 'Weekend Sizzlers', :longname => 'Weekend Sizzlers')
    Room.create(:room => 'Double Room', :description => 'Double Room')
    Room.create(:room => 'Single Room', :description => 'Single Room')
    Room.create(:room => 'Twin Room', :description => 'Twin Room')
    Room.create(:room => 'Triple Room', :description => 'Triple Room')
  end

  def self.down
    RateSpecial.delete_all
    Room.delete_all
  end
end
