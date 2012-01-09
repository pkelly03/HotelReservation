class CreateBookings < ActiveRecord::Migration
  def self.up
    create_table :bookings do |t|
      t.column :arrival_date, :date
      t.column :departure_date, :date      
      t.column :availability_id, :int
      t.column :rate_id, :int
      t.column :amount, :int
      t.column :number_of_nights, :int      
      t.column :room_id, :int
    end
  end

  def self.down
    drop_table :bookings
  end
end
