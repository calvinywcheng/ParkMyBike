class ChangeDataTypeForFieldname < ActiveRecord::Migration
  def self.up
    change_table :bike_racks do |t|
      t.change :install_year, :string
    end
  end
  def self.down
    change_table :bike_racks do |t|
      t.change :install_year, :integer
    end
  end
end