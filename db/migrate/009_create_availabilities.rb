class CreateAvailabilities < ActiveRecord::Migration
  def self.up
    create_table :availabilities do |t|
         t.column :double_room, :string
         t.column :single_room, :string
         t.column :triple_room, :string
         t.column :twin_room, :string
         t.column :booking_info_id, :int
    end
  end

  def self.down
    drop_table :availabilities
  end
end
