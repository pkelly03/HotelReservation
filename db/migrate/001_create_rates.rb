class CreateRates < ActiveRecord::Migration
  def self.up
    create_table :rates do |t|
         t.column :date, :date
         t.column :double_room, :string
         t.column :single_room, :string
         t.column :triple_room, :string
         t.column :twin_room, :string
         t.column :weekend, :boolean
         t.column :rate_special_id, :int
    end
  end

  def self.down
    drop_table :rates
  end
end