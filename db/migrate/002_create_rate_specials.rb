class CreateRateSpecials < ActiveRecord::Migration
  def self.up
    create_table :rate_specials do |t|
         t.column :shortname, :string
         t.column :longname, :string
    end
  end

  def self.down
    drop_table :rates
  end
end
