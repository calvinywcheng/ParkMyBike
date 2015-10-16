class CreateBikeRacks < ActiveRecord::Migration
  def change
    create_table :bike_racks do |t|
      t.string :street_number
      t.string :street_name
      t.string :street_side
      t.string :sky_train_station_name
      t.string :bia
      t.integer :number_of_racks
      t.string :install_year

      t.timestamps null: false
    end
  end
end
