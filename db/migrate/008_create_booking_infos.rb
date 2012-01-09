class CreateBookingInfos < ActiveRecord::Migration
  def self.up
    create_table :booking_infos do |t|
         t.column :date, :date
         t.column :weekend, :boolean
         t.column :rate_special_id, :int
    end
  end

  def self.down
    drop_table :booking_infos
  end
end
