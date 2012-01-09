class CreateAnotherModels < ActiveRecord::Migration
  def self.up
    create_table :another_models do |t|
     t.column :date_rate, :date
     t.column :amount, :int
     t.column :weekend, :boolean
     t.column :rate_id, :int
    end
  end

  def self.down
    drop_table :another_models
  end
end
