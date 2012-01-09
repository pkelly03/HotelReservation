class CreateAlterTestModels < ActiveRecord::Migration
  
  def self.up
    add_column :testmodels, :rate, :number
    add_column :testmodels, :dateFrom, :date
    add_column :testmodels, :dateTo, :date
  end

  def self.down
    remove_column :testmodels, :rate
    remove_column :testmodels, :dateFrom
    remove_column :testmodels, :dateTo
  end

end
