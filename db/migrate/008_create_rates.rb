class CreateRates < ActiveRecord::Migration
  def self.up
    create_table :rates do |t|
         t.column :shortname, :string
         t.column :longname, :string
    end
  end

  def self.down
    drop_table :rates
  end
end
