class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.column :room, :string
      t.column :description, :string      
    end
  end

  def self.down
    drop_table :rooms
  end
end
