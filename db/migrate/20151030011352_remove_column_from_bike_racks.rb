class RemoveColumnFromBikeRacks < ActiveRecord::Migration
  def change
    remove_column :bike_racks, :sky_train_station_name, :string
    remove_column :bike_racks, :bia, :string
    remove_column :bike_racks, :install_year, :integer
  end
end
