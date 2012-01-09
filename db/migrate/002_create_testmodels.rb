class CreateTestmodels < ActiveRecord::Migration
  def self.up
    create_table :testmodels do |t|
      t.column :field1, :string
      t.column :field2, :string
    end
  end

  def self.down
    drop_table :testmodels
  end
end
